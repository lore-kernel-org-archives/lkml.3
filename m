Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaKQXCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:02:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38219 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaKQXCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:02:47 -0500
Date: Tue, 18 Nov 2014 00:02:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>, x86-ml <x86@kernel.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, kan.liang@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug
 workaround
Message-ID: <20141117230232.GC25157@pd.tnic>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
 <1416251225-17721-14-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1416251225-17721-14-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 08:07:05PM +0100, Stephane Eranian wrote:
> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> 
> This patch adds a sysfs entry:
> 
> 	/sys/devices/cpu/ht_bug_workaround
> 
> to activate/deactivate the PMU HT bug workaround.
> 
> To activate (activated by default):
>  # echo 1 > /sys/devices/cpu/ht_bug_workaround
> 
> To deactivate:
>  # echo 0 > /sys/devices/cpu/ht_bug_workaround

If I put my simple-user hat and stare at this sysfs node, I'm not really
becoming any smarter from looking at the name. HT bug? A hyper-threading
bug?? I see the user forums going nuts already.

Instead of adding a sysfs node per CPU bug, I'm wondering whether adding
a

	/sys/devices/system/cpu/bugs

file which gets a mask of bits to enable and disable workarounds would
be much cleaner.

x86 guys, what do you guys think?

Such a scheme should be much more easily extensible in the future in
case we want to add another workaround toggle.

The hierarchy is not optimal either as it should be under
"perf"-something but I don't think we have a perf sysfs node...

> Results effective only once there is no more active
> events.
> 
> Reviewed-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> ---

...

>  static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
> +static DEVICE_ATTR(ht_bug_workaround, S_IRUSR | S_IWUSR, get_attr_xsu,
> +		   set_attr_xsu);
>  
>  static struct attribute *x86_pmu_attrs[] = {
>  	&dev_attr_rdpmc.attr,
> +	&dev_attr_ht_bug_workaround.attr,

You should be adding this dynamically, only when running on Intel, i.e.

	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
		/* add bug_workaround attr */

For an example, see amd_l3_attrs() in
arch/x86/kernel/cpu/intel_cacheinfo.c

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
