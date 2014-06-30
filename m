Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbaF3Tsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:48:43 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55907 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaF3Tsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:48:42 -0400
Message-ID: <53B1BF16.5010208@gmail.com>
Date: Mon, 30 Jun 2014 21:48:38 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: For testing and quality assurance of Fedora releases 
	<test@lists.fedoraproject.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: console font
References: <53A640A2.5080502@gmail.com>	<53A798F5.90801@gmail.com>	<1403497703.2887.0.camel@adam.happyassassin.net>	<53A86040.2020703@gmail.com>	<20140623173643.GB24507@wolff.to>	<1403548493.2814.4.camel@adam.happyassassin.net>	<53A896FC.5050306@earthlink.net>	<1403648029.953.1.camel@adam.happyassassin.net>	<53AA4813.9010502@earthlink.net>	<1403678098.2703.4.camel@adam.happyassassin.net>	<53AAC944.5080904@earthlink.net>	<1403709133.2701.0.camel@adam.happyassassin.net>	<53AAF2A8.5070201@earthlink.net>	<1403715952.4687.15.camel@adam.happyassassin.net> <53AB109E.40900@earthlink.net> <53AB19A2.3090709@gmail.com>
In-Reply-To: <53AB19A2.3090709@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.2014 20:49, poma wrote:
> On 25.06.2014 20:10, Felix Miata wrote:
>> On 2014-06-25 10:05 (GMT-0700) Adam Williamson composed:
>>
>>> So...these are three different machines?
>>
>> 3 out of 14 on which Rawhide is currently installed (test machines total 20+)
>> here, among which are represented various flavors of MGA (400 & 550), SiS
>> (Z7/Z9 XG20 core), Intel (810, 815, 845, 865, 915, 945, 965, 3100, 4100), ATI
>> (rv200, rv250, rv370, rv380, rv516) & NVidia for video.
>>
>>> I'm curious: why are you passing video= parameters on each one? Do
>>> any/all of them work if you don't pass that parameter?
>>
>> Most of my test machines get used most of the time with a '21"' CRT with
>> preferred mode 1600x1200 reported as preferred mode 1280x1024 used at
>> approximately 175% of normal viewing distance. Avoiding eyestrain requires
>> 1152x864 or lower on the vttys unless I want to monkey with terminal font
>> reconfiguration from default.
>>
>> My second most used test machine display is a 19" LCD TV with native mode
>> 1440x900 that reports preferred 1280x1024 but supports 4:3 modes up to
>> 1792x1344. It is used at similar distance, so also needs 1024x768 on the
>> vttys for the same reason as the CRT.
>>
>> I also have 2 15" 1024x768, 17" & 19" 1280x1024 and 20" 1600x1200 LCD puter
>> displays, 2 31.5" TVs, and an abundance of other CRTs to use as test
>> conditions require, in addition to the LCDs used for my 24/7 systems that can
>> be briefly pressed into test service when necessary.
>>
>
> # yum install terminus-fonts-console
>
> - permanent system wide
> /etc/vconsole.conf
> FONT=<Big mama font>
>
> e.g. 'latarcyrheb-sun32' or 'ter-v32b'
>
> - runtime local
> $ setfont latarcyrheb-sun32
> $ setfont ter-v32b


systemd-214-5.fc21.x86_64
kernel-3.16.0-0.rc3.git0.1.fc21.x86_64

It seems this kernel? bug is still present[2].

"rd.vconsole.font=ter-v32b" also fails to subsist due to
"fb: switching to nouveaufb from VESA VGA".

- journal systemd-vconsole-setup
systemd[1]: Starting Setup Virtual Console...
systemd-vconsole-setup[347]: putfont: KDFONTOP: Invalid argument
systemd-vconsole-setup[347]: /usr/bin/setfont failed with error code 71.
systemd[1]: Started Setup Virtual Console.

I've found so far that this can only be overcome with these two almost identical solutions;
When I thought of 'actual-vconsole-setup-start' I did not know that Yegor already done it.
Saṃsāra.


Yegor's solution[1]:
  # cp /usr/lib/systemd/system/systemd-vconsole-setup.service /etc/systemd/system/
  # diff /etc/systemd/system/systemd-vconsole-setup.service \
  > /usr/lib/systemd/system/systemd-vconsole-setup.service
  13,14c13,14
  < After=sysinit.target
  < Before=shutdown.target
  ---
  > After=systemd-readahead-collect.service systemd-readahead-replay.service
  > Before=sysinit.target shutdown.target

or even simpler - leave 'systemd-vconsole-setup.service' as is,
and make this one
/etc/systemd/system/actual-vconsole-setup-start.service:
# Actual Virtual Console Setup Start

[Unit]
Description=Actual Virtual Console Setup Start

[Service]
Type=forking
ExecStart=/usr/lib/systemd/systemd-vconsole-setup

[Install]
WantedBy=rescue.target multi-user.target

# systemctl enable actual-vconsole-setup-start.service

and now you have appropriate font size for 1920x1080,
no need to lower resolution via "video=<xres>x<yres>".
Perhaps '32' is too large, so choose <= '28', e.g. ter-v28b or ter-v24b.
/usr/share/doc/terminus-fonts-console/README[.fedora]


poma


[1] systemd-vconsole-setup: /usr/bin/setfont failed with error code 71
     http://lists.freedesktop.org/archives/systemd-devel/2011-June/002562.html

[2] Can not change console font via /etc/vconsole.conf
     https://bugzilla.redhat.com/show_bug.cgi?id=1074113

     The keyboard layout for the virtual console cannot be changed using
     “localectl set-keymap <map>; dracut -f; reboot;”
     https://bugzilla.redhat.com/show_bug.cgi?id=1033250

     font settings are lost when kernel fb drivers are changed
     https://bugzilla.redhat.com/show_bug.cgi?id=892340

     Kernel drivers lose console font settings
     https://bugzilla.redhat.com/show_bug.cgi?id=1074624

