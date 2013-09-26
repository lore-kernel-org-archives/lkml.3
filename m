Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3IZBqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:46:47 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40140 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IZBqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <2084875.Px2m8K6oH7@vostro.rjw.lan>
References: <5917186.DMyAa9ofOj@amdc1032>
	<7588112.eXrFpITlCh@vostro.rjw.lan>
	<CAH9JG2X3grVnUbuzksRLnDCT4dMQTyJuPa72qi4QmKTHo2QzEA@mail.gmail.com>
	<2084875.Px2m8K6oH7@vostro.rjw.lan>
Date: Wed, 25 Sep 2013 18:46:44 -0700
X-Google-Sender-Auth: kyS2YkenqNLzDCbK9_KZal1Btnc
Message-ID: <CAMbhsRT-a-TMr369Poo5OMyw=TMrQxpTfk-1zDFKp0YYWv7xLg@mail.gmail.com>
Subject: Re: [RFC PATCH] freezer: allow killing of frozen tasks
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kyungmin Park <kmpark@infradead.org>, Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 1:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, September 25, 2013 02:52:26 PM Kyungmin Park wrote:
>> On Tue, Aug 20, 2013 at 9:41 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Tuesday, August 20, 2013 08:27:27 AM Tejun Heo wrote:
>> >> On Tue, Aug 20, 2013 at 02:34:14PM +0200, Rafael J. Wysocki wrote:
>> >> > On Tuesday, August 20, 2013 08:22:00 AM Tejun Heo wrote:
>> >> > > On Tue, Aug 20, 2013 at 02:30:18PM +0200, Rafael J. Wysocki wrote:
>> >> > > > > So, I don't think we can simply turn TASK_UNITERRUPTIBLE to
>> >> > > > > TASK_KILLABLE at this point.  We really need to strictly define where
>> >> > > > > a task can freeze before being able to do anything like this.
>> >> > > >
>> >> > > > But we could do that for user space tasks I suppose?
>> >> > >
>> >> > > Even for userland tasks, we don't know where the task is stuck at.  I
>> >> > > think there are enough freeze points in the kernel which are in the
>> >> > > middle of something which can be used by userland tasks excuting some
>> >> > > syscall.  We need to collect all those sites into well defined trap
>> >> > > points before doing this.
>> >> >
>> >> > OK, thanks!
>> >>
>> >> I scanned through try_to_freeze() users and it seems like we don't
>> >> have that many which can be hit by userland tasks.  I think it should
>> >> be doable to audit all the users, remove the ones which can be invoked
>> >> by userland and make try_to_freeze() whine loudly if it's running off
>> >> a userland task except from well-defined spots.
>> >
>> > Which might be worth doing anyway to be sure we know what's going on.
>> >
>> >> Anyways, we need to ensure that userland task doesn't get stuck deep in the
>> >> kernel before allowing this.
>> >
>> > Agreed.
>>
>> Are there any update? we need this feature to kill frozen app easily.
>> Don't need to thaw app to kill.
>
> No updates, but the above pretty much describes what needs to be done.

FWIW, the places I added try_to_freeze (which are all accessible from
userspace tasks) were all audited to make sure they weren't holding
any shared resources.  I didn't check if they would leak any memory if
the process was killed there, but they aren't holding any locks.  It's
pretty easy to audit them, just follow the error paths up each
function - if the first error path after the freezing function doesn't
free any resources then that function is safe, and repeat for each
function that calls it.

On the other hand, would it be better to send a kill to the process
and thaw it, and let it exit before returning to userspace?
