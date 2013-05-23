Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab3EWP1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:27:14 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42905 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778Ab3EWP1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:27:09 -0400
MIME-Version: 1.0
In-Reply-To: <s5hbo81viq4.wl%tiwai@suse.de>
References: <s5h7giq86hr.wl%tiwai@suse.de>
	<s5hwqqqvw59.wl%tiwai@suse.de>
	<CACVXFVMsTjSqvyVkZEPfWgHDUJ_mqwqWy=vydCsTvv7TS-EKiQ@mail.gmail.com>
	<s5hr4gyvv7r.wl%tiwai@suse.de>
	<CACVXFVNO9FeCaJ_YFbvPMUHOBjneLqqW+ucYprZb7884Eth-DA@mail.gmail.com>
	<s5hmwrlx5np.wl%tiwai@suse.de>
	<CACVXFVMm=dKz9mwt=moU4Dw9-K=offHb10S3sV2-cxiQ5vH_cA@mail.gmail.com>
	<s5h38tdx24r.wl%tiwai@suse.de>
	<CACVXFVOy95SzeL2_wHMShZwG7eE7evrZhaEvJAsd1LLDcSD1Vw@mail.gmail.com>
	<s5hhahtvk4b.wl%tiwai@suse.de>
	<20130523144800.GB16419@redhat.com>
	<s5hbo81viq4.wl%tiwai@suse.de>
Date: Thu, 23 May 2013 23:27:08 +0800
Message-ID: <CACVXFVP=9AJKGDM8hcrCv7+dQBtsqi39AFwFO2bsUxcrsGg2wQ@mail.gmail.com>
Subject: Re: microcode loading got really slow.
From: Ming Lei <tom.leiming@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:06 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 23 May 2013 10:48:00 -0400,
> Dave Jones wrote:
>>
>> On Thu, May 23, 2013 at 04:36:20PM +0200, Takashi Iwai wrote:
>>
>>  > > >> Also udev supports user-defined rules to load firmware, which
>>  > > >> means some drivers may not put their firmware in the default
>>  > > >> path of distribution's firmware.
>>  > > >
>>  > > > It's why I suggested to put a warning in that path as the first step.
>>  > > > So we can see whether there is any actual user.
>>  > >
>>  > > If you plan to do it, it'd better to add default firmware path of some
>>  > > distributions into firmware_class.c first, otherwise it may cause
>>  > > unnecessary noise for this distribution.
>>  > >
>>  > > But if more default search paths are added, it might cause mistaken
>>  > > firmwares found under incorrect path, for example, android's
>>  > > default path is "/etc/firmware" and "/vendor/firmware"(maybe different
>>  > > for different versions).
>>  > >
>>  > > Also, putting default search paths into kernel isn't good, which was
>>  > > introduced unwillingly for well-known reason.
>>  >
>>  > Maybe we can create a new Kconfig to specify non-standard firmware
>>  > path?
>>
>> You keep mentioning non-standard paths for firmware, but in this case,
>> I don't think Fedora is doing anything unusual.  We have microcode firmware
>> in /lib/firmware/intel-ucode/ just like (afaik) everyone else.
>>
>> What *is* happening, I think is that the CPU is new enough that there's no
>> newer firmware file available for it.
>>
>> thoughts?
>
> Yes, in your case, everything is fine in the kernel itself.  And no
> microcode update is needed for new CPU, thus no firmware.

Can the driver decide if the CPU need microcode? Or there will
be the microcode for the CPU in future?

>
> The problem is that the f/w loader tries to call udev and udev gets
> stuck when invoked from module init.  This doesn't hit most drivers
> because usually the firmware is mandatory and it must exist.  Thus the
> direct f/w loading always works for them.  If it hits, it's only the
> error case.
>
> But, for the microcode loader, it's normal that the firmware doesn't
> exist, like your case.  Unfortunately, this falls back to user helper
> mode, and now you're seeing the problem.

The problem is that if driver call request_firmware(), it means it need
the firmware and it know there should be one. So maybe the driver
shouldn't call request_firmware() if it can figure out that case.

> So, the option would be to fix udev, let it behaving like before.
> The second option would be to change ("fix") the kernel behavior, but
> the question is which way.

Sounds like the microcode driver depends on userspace or filesystem
to decide if there is one microcode available for me, is the way correct?


Thanks,
-- 
Ming Lei
