Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3CPKgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 06:36:06 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:55346 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab3CPKgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 06:36:03 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: 3.8.2->3.8.3 i915 regression: GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
Date: Sat, 16 Mar 2013 11:35:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.3-dirty; KDE/4.10.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org
References: <201303142136.24917.a.miskiewicz@gmail.com>
In-Reply-To: <201303142136.24917.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303161135.59793.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 of March 2013, Arkadiusz Miskiewicz wrote:
> Hello.
> 
> After upgrading from 3.8.2 to 3.8.3 I'm getting regression :

More people hits this:
https://bugzilla.redhat.com/show_bug.cgi?id=922304
https://bugs.archlinux.org/task/34327
(seems always GM45 gpu in these reports)

archlinux people also noticed that xrandr reports VGA1 as connected (while in 
reality nothing is connected to VGA1)

[arekm@t400 ~]$ more xrandr
Screen 0: minimum 320 x 200, current 1440 x 900, maximum 32767 x 32767
LVDS1 connected 1440x900+0+0 (normal left inverted right x axis y axis) 303mm 
x 190mm
   1440x900       60.0*+   50.0  
   1024x768       60.0  
   800x600        60.3     56.2  
   640x480        59.9  
VGA1 connected 1024x768+0+0 (normal left inverted right x axis y axis) 0mm x 
0mm
   1024x768       60.0* 
   800x600        60.3     56.2  
   848x480        60.0  
   640x480        59.9  
DP1 disconnected (normal left inverted right x axis y axis)

[arekm@t400 ~]$ xrandr --output VGA --mode 1440x900
warning: output VGA not found; ignoring


Normally this looks like:
[arekm@t400 ~]$ more xrandr
Screen 0: minimum 320 x 200, current 1440 x 900, maximum 32767 x 32767                                                                                       
LVDS1 connected 1440x900+0+0 (normal left inverted right x axis y axis) 303mm 
x 190mm                                                                        
   1440x900       60.0*+   50.0                                                                                                                              
   1024x768       60.0                                                                                                                                       
   800x600        60.3     56.2  
   640x480        59.9  
VGA1 disconnected (normal left inverted right x axis y axis)
DP1 disconnected (normal left inverted right x axis y axis)

> 
> diff:
>   [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>   [drm] Driver supports precise vblank timestamp query.
>   vgaarb: device changed decodes:
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem + [drm]
> GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
> fbcon: inteldrmfb (fb0) is primary device
> - Console: switching to colour frame buffer device 180x56
> + Console: switching to colour frame buffer device 128x48
>   i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
>   i915 0000:00:02.0: registered panic notifier
>   acpi device:01: registered as cooling_device0
> 
> console becomes weird, ends up in 2/3 of screen, X when starts gets tiny
> fonts etc.
> 
> Machine is Thinkpad T400 with gm45 GPU
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 4 Series
> Chipset Integrated Graphics Controller [8086:2a42] (rev 07) (prog-if 00
> [VGA controller]) Subsystem: Lenovo Device [17aa:2112]
> 
> Reverting bisected commit from 3.8.3 fixes the problem
> 
> 2a9810441fcc26cf3f006f015f8a62094fe57a90 is the first bad commit
> commit 2a9810441fcc26cf3f006f015f8a62094fe57a90
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Sat Dec 1 21:03:22 2012 +0100
> 
>     drm/i915: reorder setup sequence to have irqs for output setup
> 
>     commit 52d7ecedac3f96fb562cb482c139015372728638 upstream.
> 
>     Otherwise the new&shiny irq-driven gmbus and dp aux code won't work
> that well. Noticed since the dp aux code doesn't have an automatic
> fallback with a timeout (since the hw provides for that already).
> 
>     v2: Simple move drm_irq_install before intel_modeset_gem_init, as
>     suggested by Ben Widawsky.
> 
>     v3: Now that interrupts are enabled before all connectors are fully
>     set up, we might fall over serving a HPD interrupt while things are
>     still being set up. Instead of jumping through massive hoops and
>     complicating the code with a separate hpd irq enable step, simply
>     block out the hotplug work item from doing anything until things are
>     in place.
> 
>     v4: Actually, we can enable hotplug processing only after the fbdev is
>     fully set up, since we call down into the fbdev from the hotplug work
>     functions. So stick the hpd enabling right next to the poll helper
>     initialization.
> 
>     v5: We need to enable irqs before intel_modeset_init, since that
>     function sets up the outputs.
> 
>     v6: Fixup cleanup sequence, too.
> 
>     Reviewed-by: Imre Deak <imre.deak@intel.com>
>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> :040000 040000 26e83b14e8d49da8c451dc2c837646a337a79085
> :fa2cbfcf159808ce188675115888242245e4e69d M      drivers
> 
> relevant dmesg:
> 
>  [drm] Initialized drm 1.1.0 20060810
>  [drm] radeon defaulting to userspace modesetting.
>  i915 0000:00:02.0: setting latency timer to 64
>  i915 0000:00:02.0: irq 47 for MSI/MSI-X
>  [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>  [drm] Driver supports precise vblank timestamp query.
>  [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin
> 5 fbcon: inteldrmfb (fb0) is primary device
>  i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
>  i915 0000:00:02.0: registered panic notifier
>  [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
