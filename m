Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3A2RSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:18:46 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50793 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3A2RSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:18:41 -0500
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma
 initramfs on slow cpu
From: anish kumar <anish198519851985@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Mike Lykov <combr@yandex.ru>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        kirill@shutemov.name
In-Reply-To: <20130129153348.GR98867@redhat.com>
References: <5107D1D3.6040105@yandex.ru> <20130129153348.GR98867@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jan 2013 22:48:27 +0530
Message-ID: <1359479907.1641.161.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 10:33 -0500, Don Zickus wrote:
> Hi Mike,
> 
> On Tue, Jan 29, 2013 at 05:42:43PM +0400, Mike Lykov wrote:
> > 
> > So my questions:
> > 
> > 1. Are there a BUG in soft lockup detection mechanizm? Changing
> > watchdog_thresh to 30 have a side effect in production - D-state
> > userspace processes will be detected slowly. Are there a need to
> > detecting soft lockups at boot time? Maybe it need after initramfs
you want to disable it then you can do that with nosoftlockup parameter
in kernel-parameters.
> > boot only when userspace processes begin to work?
If my understanding is correct you can do this as well by enabling
watchdog using sysctl.
> 
> The softlockup mechanism works scheduling a high priority task that kicks
> the softlockups.  If the unzip thread is taking too long, it could
> accidentally trip the detection.
> 
> Seeing that you are running on a 600 MHz machine, it could be possible.
> Though I am not entirely sure how the scheduling works for decompressing
> the initramfs.  I wouldn't think it is that high of a priority.
> 
> > 
> > 2. How to change watchdog_thresh parameter at boot without patching
> > sources? If it necessary (with it side effects) maybe implement it
> > as commandline parameter or config compile time parameter?
> 
> I attached a patch below that allows you to set it a boot time.  Let me
> know if this works for you, then I can clean it up and post it properly.
> 
> Cheers,
> Don
> 
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 75a2ab3..e448d63 100644
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
> +
>  static int __init nowatchdog_setup(char *str)
>  {
>  	watchdog_enabled = 0;
Sorry for digressing from the topic but I think there is something wrong
with my understanding or something wrong with the code.So I guess Don
can clarify this.
If I pass this below parameter during boot i.e. setting watchdog_enabled
to zero.
__setup("nowatchdog", nowatchdog_setup);

Now I use sysctl to enable the watchdog then wouldn't the below code
will hinder enabling the watchdog?

static void watchdog_enable_all_cpus(void)
{//snip
        if (watchdog_disabled) {  /* this is zero ?? */
                watchdog_disabled = 0;
//snip
}

Should watchdog_disabled be set to 1?Or is it that we always disable the
watchdog and then enable it?

This code is used from long time and that is the reason I am puzzled as
to how it can be wrong?I think there is some missing piece which I am
not understanding.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


