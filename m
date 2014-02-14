Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaBNHGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:06:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:42368 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaBNHGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:06:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,843,1384329600"; 
   d="scan'208";a="455341813"
From: Jani Nikula <jani.nikula@intel.com>
To: Luis Ortega <luiorpe1@upv.es>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Regression 3.14-rc2] drm/i915: Brightness adjustment is broken in 945GM
In-Reply-To: <20140213205800.GA694@Len.lan_dn>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140213153458.GA724@Len.lan_dn> <87lhxfvytk.fsf@intel.com> <20140213162422.GA765@Len.lan_dn> <20140213205800.GA694@Len.lan_dn>
User-Agent: Notmuch/0.17+61~gab0de040c7c1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 14 Feb 2014 09:09:52 +0200
Message-ID: <87ha82w4ov.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Luis Ortega <luiorpe1@upv.es> wrote:
> On Thu, Feb 13, 2014 at 05:24:23PM +0100, Luis Ortega wrote:
>> > I dare say either your bisect went sour or you don't have 945GM. Please
>> > verify your steps.
>> 
>> Well, what can I say? I was careful when testing and the last kernel I compiled
>> shows the problem. I can replay the bisection if needed but if I have to start
>> all over again it's gonna take some time. I'm compiling in the netbook and took
>> me day and a half to finish the process.
>> 
>> In all honesty, along the way I met commit messages that I thought were more
>> probable to introduce this regression. (backlight related)
>> 
>> Also, here's the output of lspci:
>> 00:00.0 Host bridge: Intel Corporation Mobile 945GSE Express Memory Controller Hub (rev 03)
>> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GSE Express Integrated Graphics Controller (rev 03)
>> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
>> 
>> > Please provide dmesg with drm.debug=0xe with 3.14-rc2.
>> 
>> Care to explain a bit more before I recompile 3.14-rc2? Do I need to
>> enable some particular debug option? How do I proceed for drm.debug=0xe?
>> 
>> 
>> Luis
>> > On Thu, Feb 13, 2014 at 05:04:23PM +0200, Jani Nikula wrote:
>> > On Thu, 13 Feb 2014, Luis Ortega <luiorpe1@upv.es> wrote:
>> > > Hi, testing 3.14-rc2 I noticed I could not adjust the brightness of the
>> > > screen any longer. This problem is already present in 3.14-rc1. 3.13 works fine.
>> > >
>> > > My hardware is a netbook with intel atom and a 945GM graphics card.
>> > >
>> > > I bisected the problem down to the next commit:
>> > 
>> > I dare say either your bisect went sour or you don't have 945GM. Please
>> > verify your steps.
>> > 
>> > Please provide dmesg with drm.debug=0xe with 3.14-rc2.
>> > 
>> > BR,
>> > Jani.
>> > 
>> > >
>> > > bc0bb9fd1c7810407ab810d204bbaecb255fddde is the first bad commit
>> > > commit bc0bb9fd1c7810407ab810d204bbaecb255fddde
>> > > Author: Jani Nikula <jani.nikula@intel.com>
>> > > Date:   Thu Nov 14 12:14:29 2013 +0200
>> > >
>> > >     drm/i915: remove QUIRK_NO_PCH_PWM_ENABLE
>> > >     
>> > >     The quirk was added as what I'd say was a stopgap measure in
>> > >     
>> > >     commit e85843bec6c2ea7c10ec61238396891cc2b753a9
>> > >     Author: Kamal Mostafa <kamal@canonical.com>
>> > >     Date:   Fri Jul 19 15:02:01 2013 -0700
>> > >     
>> > >         drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight
>> > >     
>> > >     without really digging into what was going on.
>> > >     
>> > >     Also, as mentioned in the related bug [1], having the quirk regressed
>> > >     some of the machines it was supposed to fix to begin with, and there
>> > >     were patches posted to disable the quirk on such machines [2]!
>> > >     
>> > >     The fact is, we do need the BLM_PCH_PWM_ENABLE bit set to have
>> > >     backlight. With the quirk, we've relied on BIOS to have set it, and our
>> > >     save/restore code to retain it. With the full backlight setup at enable,
>> > >     we have no place for things that rely on previous state.
>> > >     
>> > >     With the per platform hooks, we've also made a change in the PCH
>> > >     platform enable order: setting the backlight duty cycle between CPU and
>> > >     PCH PWM enable. Some experimenting and
>> > >     
>> > >     commit 770c12312ad617172b1a65b911d3e6564fc5aca8
>> > >     Author: Takashi Iwai <tiwai@suse.de>
>> > >     Date:   Sat Aug 11 08:56:42 2012 +0200
>> > >     
>> > >         drm/i915: Fix blank panel at reopening lid
>> > >     
>> > >     indicate that we can't set the backlight before enabling CPU PWM; the
>> > >     value just won't stick. But AFAICT we should do it before enabling the
>> > >     PCH PWM.
>> > >     
>> > >     Finally, any fallout we should fix properly, preferrably without quirks,
>> > >     and absolutely without quirks that rely on existing state. With the per
>> > >     platform hooks have much more flexibility to adjust the sequence as
>> > >     required by platforms.
>> > >     
>> > >     [1] https://bugzilla.kernel.org/show_bug.cgi?id=47941
>> > >     [2] http://lkml.kernel.org/r/1378229848-29113-1-git-send-email-kamal@canonical.com
>> > >     
>> > >     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> > >     Reviewed-by: Imre Deak <imre.deak@intel.com>
>> > >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> > >
>> > >
>> > > Additionally, when I had narrowed the problem to around 11 commits all the
>> > > resulting kernel I compiled made the screen blink and shake from left to right
>> > > non-stop. In the -rc kernels this doesn't happen. Thought it was worth
>> > > mentioning.
>> > 
>> > 
>> > -- 
>> > Jani Nikula, Intel Open Source Technology Center
>
>> Please provide dmesg with drm.debug=0xe with 3.14-rc2.
>
> I've booted with the kernel args drm.debug=0xe log_buf_len=16M.
> I've attached the following files for your inspection:
>
> dmesg.txt - dmesg output
> lspci.txt - output of: su -c 'lspci -nn'
> /var/log/Xorg.0.log
>
> Ask me if there is anything else I can do to help.

It seems that it will be better to track this in bugzilla rather than
the mailing lists. Please file a bug on DRM/Intel component at
https://bugs.freedesktop.org/enter_bug.cgi?product=DRI. Attach these
files.

Also, please include the output of 'ls /sys/class/backlight'. The
Xorg.0.log indicates you have a backlight device of "platform" type
which should be preferred over the "raw" intel_backlight:

> [    29.333] (--) intel(0): found backlight control interface eeepc (type 'platform')

If you try changing backlight using the sysfs under
/sys/class/backlight/<interface> using 'sudo sh -c "echo N >
brightness"' where N is a value between 0 and `cat max_brightness`, do
the interfaces there work, intel_backlight in particular?

Please include this information in the bug.

Additionally, a register dump for both the working and non-working cases
using tools/intel_reg_dumper from the intel-gpu-tools package might
prove to be helpful.


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
