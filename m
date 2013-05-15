Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3EODrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:47:08 -0400
Received: from longford.logfs.org ([213.229.74.203]:59187 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab3EODrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:47:06 -0400
Date: Tue, 14 May 2013 22:19:09 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] target: simplify target_wait_for_sess_cmds()
Message-ID: <20130515021909.GA3716@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
 <1368477007-25274-4-git-send-email-joern@logfs.org>
 <1368486003.4020.37.camel@haakon3.risingtidesystems.com>
 <20130513220057.GA24539@logfs.org>
 <1368500924.11576.16.camel@haakon3.risingtidesystems.com>
 <20130514162939.GA32463@logfs.org>
 <1368587130.9012.32.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368587130.9012.32.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 May 2013 20:05:30 -0700, Nicholas A. Bellinger wrote:
> On Tue, 2013-05-14 at 12:29 -0400, Jörn Engel wrote:
> > On Mon, 13 May 2013 20:08:44 -0700, Nicholas A. Bellinger wrote:
> > > On Mon, 2013-05-13 at 18:00 -0400, Jörn Engel wrote:
> > > > 
> > > > I agree that the overhead doesn't matter.  The msleep(100) spells this
> > > > out rather explicitly.  What does matter is that a) the patch retains
> > > > old behaviour with much simpler code and b) it fixes a race that kills
> > > > the machine.  I can live without a, but very much want to keep b. ;)
> > > 
> > > Fucking around with ->sess_cmd_lock during each loop of ->sess_cmd_list
> > > in target_wait_for_sess_cmds is not simpler code..
> > 
> > I could argue that fucking around with ->sess_cmd_lock during each
> > loop is simpler than the communication through cmd_wait_set and
> > cmd_wait_comp.  But simplicity is ultimately subjective and we can
> > argue all day.
> 
> What I don't like is the endless loop in target_wait_for_sess_cmds()
> that acquires and releases ->sess_cmd_lock for every command, with a
> hard-coded msleep thrown in.

Not for every command.  If the list is empty, it waits exactly 0x.  If
all the commands finish within 100ms, it waits exactly 1x.  Otherwise
it waits for as long as it takes, plus up to 100ms.

I agree this sucks, but the alternative was more code and we got it
wrong.  The old adage is that for every 20 lines of code you add a
bug, and these 32 lines definitely had one.  Which is why I almost
always prefer less code.

There is more to complexity than mere line count.  Your original code
also made it impossible to judge the correctness of the code without
using grep.  My loop is "either the commands eventually all complete,
or we hang forever."  Your loop was "grep for cmd_wait_set, grep for
cmd_wait_comp and check every function that lights up.  Assuming all
of that is correct, either the commands eventually all complete, or we
hang forever."

But if I cannot convince you, I guess we have to live with the bug
as-is.  Telling management that I have to spend another week of my
time and several weeks of testing for a bug that is already fixed is a
hard sell.  And even if I had that much free time and my wife didn't
complain, I don't have the necessary equipment.  So the decision is
yours.  You are the maintainer and have every right to block my patch.

Jörn

--
Modules are evil. They are a security issue, and they encourage a
"distro kernel" approach that takes forever to compile. Just say no.
Build a lean and mean kernel that actually has what you need, and nothing
more. And don't spend stupid time compiling modules you won't need.
-- Linus Torvalds
