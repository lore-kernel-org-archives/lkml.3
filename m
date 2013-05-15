Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3EODCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:02:34 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33729 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3EODCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:02:32 -0400
Message-ID: <1368587130.9012.32.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 3/3] target: simplify target_wait_for_sess_cmds()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Date: Tue, 14 May 2013 20:05:30 -0700
In-Reply-To: <20130514162939.GA32463@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
	 <1368477007-25274-4-git-send-email-joern@logfs.org>
	 <1368486003.4020.37.camel@haakon3.risingtidesystems.com>
	 <20130513220057.GA24539@logfs.org>
	 <1368500924.11576.16.camel@haakon3.risingtidesystems.com>
	 <20130514162939.GA32463@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 12:29 -0400, Jörn Engel wrote:
> On Mon, 13 May 2013 20:08:44 -0700, Nicholas A. Bellinger wrote:
> > On Mon, 2013-05-13 at 18:00 -0400, Jörn Engel wrote:
> > > 
> > > I agree that the overhead doesn't matter.  The msleep(100) spells this
> > > out rather explicitly.  What does matter is that a) the patch retains
> > > old behaviour with much simpler code and b) it fixes a race that kills
> > > the machine.  I can live without a, but very much want to keep b. ;)
> > 
> > Fucking around with ->sess_cmd_lock during each loop of ->sess_cmd_list
> > in target_wait_for_sess_cmds is not simpler code..
> 
> I could argue that fucking around with ->sess_cmd_lock during each
> loop is simpler than the communication through cmd_wait_set and
> cmd_wait_comp.  But simplicity is ultimately subjective and we can
> argue all day.
> 

What I don't like is the endless loop in target_wait_for_sess_cmds()
that acquires and releases ->sess_cmd_lock for every command, with a
hard-coded msleep thrown in.

> 
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c  |    2 +-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    2 +-
>  drivers/target/target_core_transport.c |   64 +++++++++-----------------------
>  include/target/target_core_base.h      |    2 -
>  include/target/target_core_fabric.h    |    2 +-
>  5 files changed, 20 insertions(+), 52 deletions(-)
> 
> But diffstat is reasonably objective.  Do you really want me to come
> up with an alternative patch that adds code instead of removing it?
> 

What I want is the part of Roland's commit reverted that introduced the
regression, that started you down this particular path of adding
unnecessary locking to target_wait_for_sess_cmds().

And if your using diffstat as a guide, after re-adding the handful of
parts for ->sess_wait_list from commit 1c7b13fe6 plus removing the dead
code in target_wait_for_sess_cmds(), the number of changed lines will
still be a net minus.

--nab

