Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbaBURMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:12:52 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37302 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbaBURMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:12:49 -0500
Message-ID: <5307890D.4080807@acm.org>
Date: Fri, 21 Feb 2014 11:12:45 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "rja@sgi.com" <rja@sgi.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>	 <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230>	 <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>	 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>	 <5307568C.3020701@acm.org> <1392997912.20109.41.camel@x230>
In-Reply-To: <1392997912.20109.41.camel@x230>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 09:51 AM, Matthew Garrett wrote:
> On Fri, 2014-02-21 at 07:37 -0600, Corey Minyard wrote:
>
>> However, the basic problem is that hardware vendors produce hardware
>> that sucks and then expect software to fix all the problems.  Most IPMI
>> interfaces don't have interrupts, so they have to be polled.  Then they
>> add important interfaces on top of it like firmware upgrade and ACPI and
>> expect it to perform well.  If vendors would just have an interrupt for
>> IPMI, 99% of these problems would go away.
> Not going to disagree. The impact on power consumption is also pretty
> awful. I should re-read the spec to figure out whether we can
> legitimately get away with not doing that.

Thinking about this some more, I realized that it may possible to turn
off the driver if nothing at all is waiting.  I'll need to look at the
spec to see if I'm forgetting something.

>
>> One thing we can do is remove the default interface probing for IPMI. 
>> Even though the spec has it, all modern hardware should have it
>> specified in ACPI or device tree.  That should fix all the slow boot
>> problems, at least.  If a user wants to add a default interface, they
>> can use the interface to dynamically add it after boot time.
> Something like this (untested)?

That's exactly what I would have done...

-corey

>
> diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
> index eea8464..5126230 100644
> --- a/drivers/char/ipmi/Kconfig
> +++ b/drivers/char/ipmi/Kconfig
> @@ -52,6 +52,16 @@ config IPMI_SI
>          Currently, only KCS and SMIC are supported.  If
>          you are using IPMI, you should probably say "y" here.
>  
> +config IPMI_PROBE_DEFAULTS
> +       bool 'Probe for all possible IPMI interfaces by default'
> +       help
> +         Modern systems will usually expose IPMI interfaces via a discoverable
> +        firmware mechanism such as ACPI or DMI. Older systems do not, and so
> +        the driver is forced to probe hardware manually. This may cause boot
> +        delays. Say "n" here to disable this manual probing. IPMI will then
> +        only be available on older systems if the "ipmi_si_intf.trydefaults=1"
> +        boot argument is passed.
> +
>  config IPMI_WATCHDOG
>         tristate 'IPMI Watchdog Timer'
>         help
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 03f4189..82c7d56 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1230,7 +1230,11 @@ static bool          si_tryplatform = 1;
>  #ifdef CONFIG_PCI
>  static bool          si_trypci = 1;
>  #endif
> +#ifdef CONFIG_IPMI_PROBE_DEFAULTS
>  static bool          si_trydefaults = 1;
> +#else
> +static bool          si_trydefaults;
> +#endif
>  static char          *si_type[SI_MAX_PARMS];
>  #define MAX_SI_TYPE_STR 30
>  static char          si_type_str[MAX_SI_TYPE_STR];
>
>

