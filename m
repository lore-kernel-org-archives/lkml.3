Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab3KMQb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:31:27 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44035 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533Ab3KMQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:31:25 -0500
Message-Id: <1384360284.28215.47013129.162FF17C@webmail.messagingengine.com>
X-Sasl-Enc: g/XVnph7HvS1qsrp9zkvi6YRbn+JRT4dy8sKC/F1sxnF 1384360284
From: randmedia@123mail.org
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-d4893488
Subject: How to correctly disable LIRC-related MCE*/IR_* modules,
 to remove ID of RemoteControl as BOTH keyboard & remote?
Date: Wed, 13 Nov 2013 08:31:24 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working on setup of an IR RemoteControl.  Specifically, a
'Streamzap' IR remote, with its included USB-connected IR receiver.

I'm configuring it as a LIRC remote _only_, in a specific app (XBMC,
fwiw), and NOT as a keyboard/remote in/for any other app.

I've been unable to manage disabling conflicts between the
assignment/registration of the IR Remote as BOTH a keyboard & a remote. 
I'd like to learn how to effectively DISable the interfering modules;
without necessarily having to recompille the kernel.

Here's what I'm seeing.

On Linux kernel -- whether

	uname -a
		Linux rpi.loc 3.10.18 #2 PREEMPT Tue Nov 12 16:04:38 UTC
		2013 armv6l GNU/Linux

@ an arm-based RaspberryPi, or

	uname -a
		Linux desk.loc 3.7.10-1.16-desktop #1 SMP PREEMPT Fri
		May 31 20:21:23 UTC 2013 (97c14ba) x86_64 x86_64 x86_64
		GNU/Linux

@ an x86_64 desktop, I find @ boot that the attached device is
recognized & registered as an MCE device (here, e.g., @ Rpi),

	dmesg | egrep -i "stream|lirc"
		[    4.537755] usb 1-3.1: Product: Streamzap Remote
		Control
		[    4.537756] usb 1-3.1: Manufacturer: Streamzap, Inc.
		[   17.122902] Registered IR keymap rc-streamzap
		[   17.134146] input: Streamzap PC Remote Infrared
		Receiver (0e9c:0000) as
		/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3.1/1-3.1:1.0/rc/rc0/input8
		[   17.134244] rc0: Streamzap PC Remote Infrared
		Receiver (0e9c:0000) as
		/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3.1/1-3.1:1.0/rc/rc0
		[   17.134315] streamzap 1-3.1:1.0: Registered
		Streamzap, Inc. Streamzap Remote Control on usb1:4
		[   17.219672] IR RC5 (streamzap) protocol handler
		initialized
		[   17.290559] usbcore: registered new interface driver
		streamzap
>>>		[   17.417754] input: MCE IR Keyboard/Mouse (streamzap) as /devices/virtual/input/input9
		[   17.469336] lirc_dev: IR Remote Control driver
		registered, major 249
		[   17.486010] rc rc0: lirc_dev: driver ir-lirc-codec
		(streamzap) registered at minor = 0
		[   17.507386] IR LIRC bridge handler initialized

which is not what I want.

To prevent that, I've tried to blacklist MCE* and IR_RC5* drivers in
/etc/modprobe.d/{blacklist,MODULE}.conf, to no effect.  The
registration, and the load of associated modules, still occurs, as seen
in dmesg.

This has the result that I've been experiencing conflicts between
keypresses being recognized as MCE 'keyboard' presses and LIRC 'remote'
keypresses.

Where there's an X server in use, reading

	http://wiki.xbmc.org/index.php?title=How-to:Setup_Streamzap_PC_Remote_for_Linux#Xinput:_Preventing_Streamzap_from_becoming_a_keyboard

and editing

	cat /etc/X11/xorg.conf.d/05-streamzap.conf
		Section "InputClass"
		    Identifier "Ignore Streamzap IR as KEYBOARD or
		    MOUSE"
		     MatchIsKeyboard "on"
		    MatchProduct "treamzap|MCE IR"
		    Option "Ignore" "true"
		EndSection

manages to prevent the MCE-related conflict.  However, where there's NO
X env, e.g. on the RPi, I lose that option.

Working on the RPi, I finally got this under control by recompiling its
kernel, setting the kernel config specifically to DISable the unwanted
MCE* and IR_* modules,

	CONFIG_LIRC=m
	CONFIG_IR_LIRC_CODEC=m
	CONFIG_IR_STREAMZAP=m
	CONFIG_IR_MCE_KBD_DECODER=n
	CONFIG_IR_MCEUSB=n
	CONFIG_LIRC_STAGING=n
	CONFIG_IR_JVC_DECODER=n
	CONFIG_IR_NEC_DECODER=n
	CONFIG_IR_RC5_DECODER=n
	CONFIG_IR_RC5_SZ_DECODER=n
	CONFIG_IR_RC6_DECODER=n
	CONFIG_IR_SANYO_DECODER=n
	CONFIG_IR_SONY_DECODER=n
	CONFIG_LIRC_IGORPLUGUSB=n
	CONFIG_LIRC_IMON=n
	CONFIG_LIRC_RPI=n
	CONFIG_LIRC_XBOX=n
	CONFIG_LIRC_SASEM=n
	CONFIG_LIRC_SERIAL=n
	CONFIG_LIRC_SERIAL_TRANSMITTER=n
	CONFIG_LIRC_SIR=n
	CONFIG_LIRC_ZILOG=n

Now, @ Rpi, I've simply

	lsmod | egrep -i "sz|streamzap|lirc"
		ir_lirc_codec           3100  3 
		lirc_dev                7036  1 ir_lirc_codec
		rc_streamzap             668  0 
		streamzap               3425  0 
		rc_core                11688  4
		streamzap,ir_lirc_codec,rc_streamzap

and setup of standalone LIRC-daemon connection/use of the remote is as
expected -- remote-only, and no interruptions/intererference by
'keyboard' assignments, in-/out-side of the current target app, XBMC.

So, I have a workaround that meets my need.  Atm, it appears to require
the seemingly heavy-handed recompile of the kernel, cleaned of the
unwanted Media modules.

I'd prefer to avoid the hassle, and use standard distro kernel, but
manage to effectively disable the unwanted/interfering modules.

What's the correct/effective method to turn off specifically the
unwanted MCE*/IR_* interference, whether disable the modules, or other
method?

rand
