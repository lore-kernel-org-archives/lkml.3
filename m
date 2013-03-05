Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3CEWSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:18:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3CEWST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:18:19 -0500
Date: Tue, 5 Mar 2013 14:18:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Artem Savkov <artem.savkov@gmail.com>
Subject: Re: [PATCH] thinkpad-acpi: fix potential suspend blocking issue
Message-Id: <20130305141817.4e27e83aa66598115e52eb9e@linux-foundation.org>
In-Reply-To: <1362504883-9180-1-git-send-email-msb@chromium.org>
References: <201303042055.38040.maciej.rutecki@gmail.com>
	<1362504883-9180-1-git-send-email-msb@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Mar 2013 09:34:43 -0800 Mandeep Singh Baines <msb@chromium.org> wrote:

> Fixes the following lockdep error:
> 
> [ BUG: ktpacpi_nvramd/446 still has locks held! ]
> 
> hotkey_kthread() calls set_freezable() after acquiring the
> hotkey_kthread_mutex(). set_freezable() calls try_to_freeze().
> This could block suspend if we were to freeze at this point
> and another task were to block on the mutex, potentially via
> writing to one of the sysfs attrs. This race is unlikely but
> can be easily fixed by moving the set_freezable() call.
>
> ...
>
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -2462,13 +2462,13 @@ static int hotkey_kthread(void *data)
>  	unsigned int poll_freq;
>  	bool was_frozen;
>  
> +	set_freezable();
> +
>  	mutex_lock(&hotkey_thread_mutex);
>  
>  	if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
>  		goto exit;
>  
> -	set_freezable();
> -
>  	so = 0;
>  	si = 1;
>  	t = 0;

Basically the same as
http://ozlabs.org/~akpm/mmots/broken-out/drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable.patch.
 I think Artem's patch is a little better.  There doesn't appear to be
any locking protocol for tpacpi_lifecycle.

I'll move Artem's patch into my for-3.9-rc2 queue.
