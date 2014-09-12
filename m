Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaILFsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 01:48:39 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:55054 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaILFsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 01:48:37 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.172.182]
In-Reply-To: <CAB=NE6XmFaWMKuW3vJ7QMZ1BmmWrAPezTYYsqatX4mMNdMjpog@mail.gmail.com>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
 <CAB=NE6Wti1RpAFk5q_YeZn2F9Rd=wsiwhyPszu74nG9fXwH5vQ@mail.gmail.com>
 <20140905141241.GC10455@mtj.dyndns.org> <20140905164405.GA28964@core.coreip.homeip.net>
 <20140905174925.GA12991@mtj.dyndns.org> <CAB=NE6VPTV39pNujOgO422wbUvU44HZ7s=aaxPVraNECqA6e4Q@mail.gmail.com>
 <20140905224047.GC15723@mtj.dyndns.org> <CAB=NE6Uz1VD5qpMFSBfQRV8ih9FQcCUhNtWMvD38t5hdDvix4Q@mail.gmail.com>
 <20140909011059.GB11706@mtj.dyndns.org> <1410241109.2028.22.camel@jarvis.lan>
 <CAB=NE6WGAMvffGDTkN5x5Cd+YOtD-Cmo3v7_8FmJ5cvCRbFEpw@mail.gmail.com>
 <1410291346.13298.16.camel@jarvis.lan> <CAB=NE6U6v-GhAaZv3yXn9uVFvBvE4Uq8z7MQU8N+CyW19WpnNQ@mail.gmail.com>
 <CAG-2HqUiUksdT4UyeDsdc1Q74=2BiX2TuzzGh_hoLiO5_DOvXQ@mail.gmail.com>
 <CAB=NE6UprJH69hzc1mjqyq6PAn+7LZmX65Z8CDwUdJ73nDusHg@mail.gmail.com>
 <CAG-2HqUzCvd55mq=M3=tXbHAjc2QnVuRtbFZMWTz9k_6BmmngQ@mail.gmail.com> <CAB=NE6XmFaWMKuW3vJ7QMZ1BmmWrAPezTYYsqatX4mMNdMjpog@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 12 Sep 2014 07:48:16 +0200
Message-ID: <CAG-2HqWYXo+uRtOk_XW-Bi5aXcTLphEMLCMy8a2THuEg9dHPzw@mail.gmail.com>
Subject: Re: [systemd-devel] [RFC v2 3/6] kthread: warn on kill signal if not OOM
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Tejun Heo <tj@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Takashi Iwai <tiwai@suse.de>, Kay Sievers <kay@vrfy.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        hare <hare@suse.com>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Wu Zhangjin <falcon@meizu.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "mpt-fusionlinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 12:26 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Thu, Sep 11, 2014 at 2:43 PM, Tom Gundersen <teg@jklm.no> wrote:
>> How about simply introducing a new flag to finit_module() to indicate
>> that the caller does not care about asynchronicity. We could then pass
>> this from udev, but existing scripts calling modprobe/insmod will not
>> be affected.
>
> Do you mean that you *do want asynchronicity*?

Precisely, udev would opt-in, but existing scripts etc would not.

>> But isn't finit_module() taking a long time a serious problem given
>> that it means no other module can be loaded in parallel?
>
> Indeed but having a desire to make the init() complete fast is
> different than the desire to have the combination of both init and
> probe fast synchronously.

I guess no one is arguing that probe should somehow be required to be
fast, but rather:

> If userspace wants init to be fast and let
> probe be async then userspace has no option but to deal with the fact
> that async probe will be async, and it should then use other methods
> to match any dependencies if its doing that itself.

Correct. And this therefore likely needs to be opt-in behaviour per
finit_module() invocation to avoid breaking old assumptions.

> For example
> networking should not kick off after a network driver is loaded but
> rather one the device creeps up on udev. We should be good with
> networking dealing with this correctly today but not sure about other
> subsystems. depmod should be able to load the required modules in
> order and if bus drivers work right then probe of the remnant devices
> should happen asynchronously. The one case I can think of that is a
> bit different is modules-load.d things but those *do not rely on the
> timeout*, but are loaded prior to a service requirement. Note though
> that if those modules had probe and they then run async'd then systemd
> service would probably need to consider that the requirements may not
> be there until later. If this is not carefully considered that could
> introduce regression to users of modules-load.d when async probe is
> fully deployed. The same applies to systemd making assumptions of kmod
> loading a module and a dependency being complete as probe would have
> run it before.

Yeah, these all needs to be considered when deciding whether or not to
enable async in each specific case.

> I believe one concern here lies in on whether or not userspace
> is properly equipped to deal with the requirements on module loading
> doing async probing and that possibly failing. Perhaps systemd might
> think all userspace is ready for that but are we sure that's the case?

There almost certainly are custom things out there relying on the
synchronous behaviour, but if we make it opt-in we should not have a
problem.

Cheers,

Tom
