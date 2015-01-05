Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbbAENUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:20:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:43249 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbbAENT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:19:59 -0500
X-IronPort-AV: E=Sophos;i="5.07,700,1413244800"; 
   d="scan'208";a="210780133"
Message-ID: <54AA8F7C.6000006@citrix.com>
Date: Mon, 5 Jan 2015 13:19:56 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>, <x86@kernel.org>
CC: Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Laszlo Ersek <lersek@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] x86/xen: avoid freeing static 'name' when
 kasprintf() fails
References: <1420463205-19249-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1420463205-19249-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/15 13:06, Vitaly Kuznetsov wrote:
> In case kasprintf() fails in xen_setup_timer() we assign name to the static
> string "<timer kasprintf failed>". We, however, don't check that fact before
> issuing kfree() in xen_teardown_timer(), kernel is supposed to crash with
> 'kernel BUG at mm/slub.c:3341!'
> 
> Solve the issue by making name a fixed length string inside struct
> xen_clock_event_device. 16 bytes should be enough.
> 
> The issue was discovered by Laszlo Ersek.

Add Reported-by: Laszlo ... tag perhaps?

> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -391,7 +391,7 @@ static const struct clock_event_device *xen_clockevent =
>  
>  struct xen_clock_event_device {
>  	struct clock_event_device evt;
> -	char *name;
> +	char name[16];
>  };
>  static DEFINE_PER_CPU(struct xen_clock_event_device, xen_clock_events) = { .evt.irq = -1 };
>  
> @@ -420,14 +420,11 @@ void xen_teardown_timer(int cpu)
>  	if (evt->irq >= 0) {
>  		unbind_from_irqhandler(evt->irq, NULL);
>  		evt->irq = -1;
> -		kfree(per_cpu(xen_clock_events, cpu).name);
> -		per_cpu(xen_clock_events, cpu).name = NULL;
>  	}
>  }
>  
>  void xen_setup_timer(int cpu)
>  {
> -	char *name;
>  	struct clock_event_device *evt;

struct xen_clock_event_device *xevt = ...;

>  	int irq;
>  
> @@ -438,21 +435,19 @@ void xen_setup_timer(int cpu)
>  
>  	printk(KERN_INFO "installing Xen timer for CPU %d\n", cpu);
>  
> -	name = kasprintf(GFP_KERNEL, "timer%d", cpu);
> -	if (!name)
> -		name = "<timer kasprintf failed>";
> +	snprintf(per_cpu(xen_clock_events, cpu).name, 16, "timer%d", cpu);

Use sizeof(xevt->name) here.

David
