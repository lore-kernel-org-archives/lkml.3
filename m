Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3A2X7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:59:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3A2X7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:59:18 -0500
Date: Tue, 29 Jan 2013 15:59:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Mike Lykov <combr@yandex.ru>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma
 initramfs on slow cpu
Message-Id: <20130129155917.4ee64214.akpm@linux-foundation.org>
In-Reply-To: <20130129153348.GR98867@redhat.com>
References: <5107D1D3.6040105@yandex.ru>
	<20130129153348.GR98867@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 10:33:48 -0500
Don Zickus <dzickus@redhat.com> wrote:

> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -79,6 +79,14 @@ static int __init softlockup_panic_setup(char *str)
>  }
>  __setup("softlockup_panic=", softlockup_panic_setup);
>  
> +static int __init watchdog_thresh_setup(char *str)
> +{
> +	watchdog_thresh = simple_strtoul(str, NULL, 0);
> +
> +	return 1;
> +}
> +__setup("watchdog_thresh=", watchdog_thresh_setup);

I wonder if there's some magical way in which we can set any sysctl
from the kernel command line.  Add sys.vm.min_free_kbytes=42 to the
command line, walk the hierarchy late in boot...

To address Mike's bug I suggest we poke a touch_softlockup_watchdog()
into the appropriate place.  Presumably the loop in
lib/decompress_unlzma.c:unlzma().  The decompress code makes me cry.
