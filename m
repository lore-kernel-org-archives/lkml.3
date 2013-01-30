Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3A3P7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:59:31 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63196 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3A3P72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:59:28 -0500
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma
 initramfs on slow cpu
From: anish kumar <anish198519851985@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Mike Lykov <combr@yandex.ru>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        kirill@shutemov.name
In-Reply-To: <20130130155121.GF98867@redhat.com>
References: <5107D1D3.6040105@yandex.ru> <20130129153348.GR98867@redhat.com>
	 <1359479907.1641.161.camel@anish-Inspiron-N5050>
	 <20130130155121.GF98867@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jan 2013 21:29:12 +0530
Message-ID: <1359561552.1641.218.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 10:51 -0500, Don Zickus wrote:
> On Tue, Jan 29, 2013 at 10:48:27PM +0530, anish kumar wrote:
> > Sorry for digressing from the topic but I think there is something wrong
> > with my understanding or something wrong with the code.So I guess Don
> > can clarify this.
> > If I pass this below parameter during boot i.e. setting watchdog_enabled
> > to zero.
> > __setup("nowatchdog", nowatchdog_setup);
> > 
> > Now I use sysctl to enable the watchdog then wouldn't the below code
> > will hinder enabling the watchdog?
> > 
> > static void watchdog_enable_all_cpus(void)
> > {//snip
> >         if (watchdog_disabled) {  /* this is zero ?? */
> >                 watchdog_disabled = 0;
> > //snip
> > }
> > 
> > Should watchdog_disabled be set to 1?Or is it that we always disable the
> > watchdog and then enable it?
> 
> It seems like a bug, so does something like this fix it?  There is
> probably a better way to handle the internal representation of the
> watchdog state (watchdog_disable) and the procfs version
> (watchdog_enable), but I just can't think of something right now. :-(
> 
> Cheers,
> Don
> 
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 75a2ab3..d287726 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -82,6 +82,7 @@ __setup("softlockup_panic=", softlockup_panic_setup);
>  static int __init nowatchdog_setup(char *str)
>  {
>  	watchdog_enabled = 0;
> +	watchdog_disabled =1;
I don't know if this will work or not but while going through the code I
spotted this.I will think of something better if I couldn't think of
anything better than anyway we have this patch.
>  	return 1;
>  }
>  __setup("nowatchdog", nowatchdog_setup);


