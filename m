Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3EOGCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:02:13 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:58063 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3EOGCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:02:11 -0400
Message-ID: <1368597902.14770.11.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 3/3] target: simplify target_wait_for_sess_cmds()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Date: Tue, 14 May 2013 23:05:02 -0700
In-Reply-To: <20130515021909.GA3716@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
	 <1368477007-25274-4-git-send-email-joern@logfs.org>
	 <1368486003.4020.37.camel@haakon3.risingtidesystems.com>
	 <20130513220057.GA24539@logfs.org>
	 <1368500924.11576.16.camel@haakon3.risingtidesystems.com>
	 <20130514162939.GA32463@logfs.org>
	 <1368587130.9012.32.camel@haakon3.risingtidesystems.com>
	 <20130515021909.GA3716@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 22:19 -0400, Jörn Engel wrote:
> On Tue, 14 May 2013 20:05:30 -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2013-05-14 at 12:29 -0400, Jörn Engel wrote:
> > > On Mon, 13 May 2013 20:08:44 -0700, Nicholas A. Bellinger wrote:
> > > > On Mon, 2013-05-13 at 18:00 -0400, Jörn Engel wrote:
> > > > > 
> > > > > I agree that the overhead doesn't matter.  The msleep(100) spells this
> > > > > out rather explicitly.  What does matter is that a) the patch retains
> > > > > old behaviour with much simpler code and b) it fixes a race that kills
> > > > > the machine.  I can live without a, but very much want to keep b. ;)
> > > > 
> > > > Fucking around with ->sess_cmd_lock during each loop of ->sess_cmd_list
> > > > in target_wait_for_sess_cmds is not simpler code..
> > > 
> > > I could argue that fucking around with ->sess_cmd_lock during each
> > > loop is simpler than the communication through cmd_wait_set and
> > > cmd_wait_comp.  But simplicity is ultimately subjective and we can
> > > argue all day.
> > 
> > What I don't like is the endless loop in target_wait_for_sess_cmds()
> > that acquires and releases ->sess_cmd_lock for every command, with a
> > hard-coded msleep thrown in.
> 
> Not for every command.  If the list is empty, it waits exactly 0x.  If
> all the commands finish within 100ms, it waits exactly 1x.  Otherwise
> it waits for as long as it takes, plus up to 100ms.
> 
> I agree this sucks, but the alternative was more code and we got it
> wrong.  The old adage is that for every 20 lines of code you add a
> bug, and these 32 lines definitely had one.  Which is why I almost
> always prefer less code.
> 

I'd rather judge by the code itself, rather than by some artificial line
count.  Especially when the few lines we're talking about reinstating
are two pieces of initialization and single list_splice().

> There is more to complexity than mere line count.  Your original code
> also made it impossible to judge the correctness of the code without
> using grep.  My loop is "either the commands eventually all complete,
> or we hang forever."  Your loop was "grep for cmd_wait_set, grep for
> cmd_wait_comp and check every function that lights up.  Assuming all
> of that is correct, either the commands eventually all complete, or we
> hang forever."
> 
> But if I cannot convince you, I guess we have to live with the bug
> as-is.

Fine.  I'll post a patch shortly for the version that I'd prefer, and
you can include it into the test setup at your leisure.

Feel free to complain if you think it's logically incorrect.

>   Telling management that I have to spend another week of my
> time and several weeks of testing for a bug that is already fixed is a
> hard sell.  And even if I had that much free time and my wife didn't
> complain, I don't have the necessary equipment.  So the decision is
> yours.  You are the maintainer and have every right to block my patch.
>

Not sure what to say here.  The end result for how the logic actually
works is AFAICT the same, I just don't like the extra lock acquire +
releases and the hardcoded msleep.

--nab

