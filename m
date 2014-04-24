Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaDXUFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:05:44 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:47911 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaDXUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <CALhHN=oYVjMqQG8XyHuWik14R6hGUSbt986YLXqH361gio6CjQ@mail.gmail.com>
References: <1397645621-32447-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6VNHBrk+HWGLZxNOBFXsGv6XLQus8zTx-AP2Ye6jbgnPA@mail.gmail.com> <CALhHN=oYVjMqQG8XyHuWik14R6hGUSbt986YLXqH361gio6CjQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 24 Apr 2014 13:05:20 -0700
X-Google-Sender-Auth: EiKff0T3q87C5o45YHJxvTnm9qM
Message-ID: <CAB=NE6U631JBCXMx_foeC7-LtiyA94XP3sc5FBFsoeL1mYC4jQ@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: reg: track crda request
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Lennart Poettering <mzoybt@0pointer.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 12:24 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 22 April 2014 19:33, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
>> As is, we don't ever bail out and could end up triggering CRDA to be
>> called every ~3 seconds with this patch. This is why I had added the
>> opportunistic triggers, which are technically still in place today but
>> there are only a few entries for those to kick off: beacon hints on 5
>> GHz for cards that enable beacon hints. I don't think its a good idea
>> we have a a recurring timer trigger for this. I think we need to
>> consider a time at which we should give up on CRDA being present and
>> instead rely on userspace to let us know its ready (ideally userspace
>> would do something with inotify on the path) so we can kick the queue
>> again.
>>
>
> I think about such counter/limitation before.
> But next I remove such counter.
> In case we don't have CRDA nor using INTERNAL_REGD - this mean we
> don't have correct regulatory configuration.

Just a clarification -- by don't have correct regulatory configuration
you mean 'limited' regulatory configuration, or restricted -- the
world regulatory domain.

> Why then should we stop warning about this?

WARN_ONCE() should solve this and get users / system integrators who
don't install either to do so, having a message pop up on the log ever
3 seconds however is doomed to cause a rant by anyone. An example
reasonable complaint might come from system integrators who are
comfortable with the restricted world regulatory domain, or by some
system integrators who are OK with the custom regulatory domains which
some drivers have that the API supports. Filling up their hard drive's
is not nice, specially if we can avoid it sensibly.

I'm learning that with systemd's socket activation support [0] we
should have a guarantee that any messages sent by the kernel even
early can can eventually be eaten up by udev, but what is unclear to
me is if udev will queue up any pending requests for rules to be
triggered for a binary which is on a filesystem not yet mounted. In
other words -- I think we should strive to solve this on userspace as
adding support for this in the kernel seems silly if we can do it in
userspace to solve all similar type of udev event rule dependency on
binaries.

Since I am not exactly sure if without systemd udev will get all
kernel events, even during early boot, I do think having something
sort of timeout for now maybe with WARN_ONCE() is reasonable but do
not think something recurring would be good.

[0] http://0pointer.de/blog/projects/socket-activation.html

> In case we will have counter eg. 10 x 3 seconds, we can't be sure if that is:
> - not mounted fs (fsck other ...) case

Hadn't considered at what point a forced long fsck might last but
again this is an issue other udev rules would run into as well.

> - there isn't any CRDA in the system (quite possible when using openwrt) case

Well we can distinguish this by the type of call that set the
regulatory domain, if the db.txt was compiled into the kernel cfg80211
manages setting that, so we can distinguish there if needed, right now
set_regdom() doesn't tell us if an internal db was used or not, but
that can easily change. Also if we need to change code to behave
differently for the timeout consideration, or maybe disregard it,
config_enabled(CONFIG_CFG80211_INTERNAL_REGDB) can be used.

> - when have a lot of messages in dmesg you will not know there is not
> CRDA in the system

Since you broke out the different cases -- I think this timeout seems
to make more sense now only if CONFIG_CFG80211_INTERNAL_REGDB was not
enabled, at least using WARN_ONCE() as that can be important for any
system integrator, but CONFIG_CFG80211_INTERNAL_REGDB was enabled a
simple info message stating CRDA was not found seems reasonable.

> In case of recurring timer when you will check dmes you will be sure
> there isn't any CRDA binary - and there will be clear message about
> this.
> Because of that I didn't add this counter.

I think we can do better, let me know what you think of the above.

  Luis
