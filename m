Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968047Ab3E3J0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:26:54 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54698 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967400Ab3E3J0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:26:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130530103444.40888460@endymion.delvare>
References: <20130529102735.3ce72ecc@endymion.delvare>
	<878v2xmgmw.fsf@rustcorp.com.au>
	<CAK7N6vpv6JpsXEdjLOUd-+7+y=DB9Q-zcMdj12iZWu=bGkAieQ@mail.gmail.com>
	<20130530103444.40888460@endymion.delvare>
Date: Thu, 30 May 2013 14:56:43 +0530
Message-ID: <CAK7N6vo+2F98CfibfTUn9fbkxEXjBVQi1cxpvK0L7XCSq8xaDQ@mail.gmail.com>
Subject: Re: What is listed in /sys/module?
From: anish singh <anish198519851985@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 2:04 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Rusty,
>
> Thanks for the fast and helpful reply.
>
> On Thu, 30 May 2013 11:53:10 +0530, anish singh wrote:
>> On Thu, May 30, 2013 at 6:24 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> > Jean Delvare <khali@linux-fr.org> writes:
>> >> Hi Greg, Rusty,
>> >>
>> >> I have a question related to /sys/module and can't seem to find the
>> >> answer by myself so I hope you can explain.
>> >>
>> >> I noticed that /sys/module contains more than /proc/modules. At first I
>> >> thought that any potentially modular piece of code would show up
>> >> in /sys/module, so /sys/module would include both actual modules and
>> >> "built-in modules".
>> >>
>> >> However I then noticed that some built-in modules do _not_ show up
>> >> in /sys/module. For example, I have USB and I2C core support built into
>> >> my 3.9.4 kernel, /sys/module/usbcore exists but /sys/module/i2c_core
>> >> does not. CONFIG_SENSORS_W83795=y did not give me /sys/module/w83795
>> >> either.
>> >
>> > Yes.  /sys/module entries are created for builtin "modules" with
>> > parameters.  This is because, the module names are discovered by
>
> Apparently having a module version defined is enough as well. For
> example xz_dec has no parameters, but it has a version,
> and /sys/module/xz_dec is created when built-in. The code for that is
> in version_sysfs_builtin().
>
>> So documentation is wrong about that.
>
> It is incomplete, as it doesn't mention any condition
> to /sys/module/MODULENAME being created, yes. I'll send a patch -
> unless someone has a plan to fix the issue itself.
>
>> > scouring the parameters: see param_sysfs_builtin().
>> >
>> > Two things to note about builtin modules:
>> >
>> > 1) There is nothing other than parameters in /sys/module/, except a
>> >    uevent which is used for managing the parameters.  So, without
>> >    parameters, it would be an empty directory.
>> >
>> > 2) We actually do generate a list of builtin modules these days, called
>> >    modules.builtin.  So we could generate sysfs dirs from this.
>>
>> As I understand modules.builtin is the output of the kernel compilation.
>> So if we want to make /sys/module consistent then this file needs to
>> be parsed by kernel and corresponding sysfs created but what is the
>
> I don't know what you have in mind exactly, but I don't think the
> kernel is ever going to parse a user-space file (which may or may not
> be available at run-time, BTW.)

Well it does that in case of loading firmwares(loading from userspace)
but that is a different story altogether.
>
> Using include/config/tristate.conf directly seems impossible as well,
> as the kernel code has no way to look-up the module name from the
> Kconfig symbol name - only the build system knows it.
>
> So any approach based on modules.builtin or
> include/config/tristate.conf is going to be very tricky, I'm afraid. It
> might be easier to create a dummy section for built-in modules. This
> could be added to module_init(), except that some modules use
> postcore_initcall() or some such instead. Or maybe we have to create a
> dedicated call for it, but that would be touching a huge number of
> files - unless we make it optional. I can't think of a simple and clean
> solution, I'm afraid.
>
>> point of creating just the sysfs without having any parameters information
>> which is why this /sys/module exists in the first place right?
>
> My question was motivated by work I'm doing on the sensors-detect
> script. The purpose of that script is to tell the user which modules
> he/she should load to get hardware monitoring running on his/her
> system. The script has to load some modules for the detection itself
> (e.g. cpuid, i2c-dev, SMBus controller drivers) and outputs a list of
> drivers which should be loaded by the user (but the script itself does
> not load them.)
>
> Each of the drivers in question can be completely missing, or built-in,
> or built as a module but not loaded, or built as a module and loaded.
> In order to make the script as user-friendly as possible, we have to
> handle each case properly. If the driver is missing, we want to tell
> the user that we can't do the detection completely (if the driver was
> needed for probing) or he/she won't be able to make full use of the
> hardware (if the driver was needed for run-time.) If the driver is
> built-in or already loaded module, then all is fine, we don't have to
> load it (for probing) nor to tell the user to do it (for run-time.) If
> the driver is modular, we have to load and then unload it (for probing)
> or tell the user to do so (for run-time.) So we have 4 cases to handle:
>
> 1* Driver missing
> 2* Driver built-in
> 3* Module not loaded
> 4* Module loaded
>
> Case 4 is the easy one, we just look at /proc/modules. But having no
> way to tell if a given driver is built-in, makes it impossible to

 modprobe -l doesn't work?
> distinguish between cases 1, 2 and 3. Of course we can try to load the
> module anyway and see what happens, but then we have no way to tell a
> harmless failure (driver build-in) from a harmful one (driver missing).
> It is also harder (although not impossible) to cleanly unload the
> modules afterward (we want to rmmod only drivers we successfully loaded
> ourselves.)
>
> That problem can be solved by parsing /lib/modules/$(uname -r)/modules.builtin
> from sensors-detect directly. Thanks a lot for the suggestion, I had
> not considered it. It should work just fine so I'll implement that. And
> it will work for all kernels which have this file. I don't know when
> we started creating it exactly, apparently since kernel version 2.6.33.
>
> Additionally, when some hwmon drivers are already loaded, this prevents
> us from doing the hardware detection. In that case we still try to tell
> the user what hardware monitoring device he/she has, and for that we
> need to look-up the module name from the kernel device name. Getting
> the driver name from the device name always works, but getting the
> module name (which may differ from the driver name) not always: it
> works fine for modular drivers as they have a "module" link
> to /sys/module/$module, but the link is missing if /sys/module/$module
> doesn't exist (built-in driver with no parameter and no version.)
>
> I have no solution for that second problem, until /sys/module/$module
> is created unconditionally for all built-in drivers.
>
>> > If you want to make it consistent, I look forward to your patch!
>>
>> I would be interested here.
>
> I have no immediate idea how to implement that, sorry :(
>
> Thanks,
> --
> Jean Delvare
