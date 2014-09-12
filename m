Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaILX7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:59:46 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:59567 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaILX7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:59:44 -0400
Date: Sat, 13 Sep 2014 08:59:35 +0900
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140912235935.GB28183@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <1609685.fbsF6EQ3X7@vostro.rjw.lan>
 <CAM_iQpXiJL=q6NFkiPF71dZHKXu=ReJ59Rbadc__+UX-GW2x8A@mail.gmail.com>
 <4809128.C6aPga5IjQ@vostro.rjw.lan>
 <CAM_iQpXwEEoCTqksFEyJ7UigOJkf6g5UHnddEHcMDjwKz6K-DQ@mail.gmail.com>
 <CAM_iQpUP9kSGMs6Lq9tBLGaJrW6yyBWU5z38WzBiH4x-H_ZdYA@mail.gmail.com>
 <20140911163004.GN22042@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911163004.GN22042@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 06:30:04PM +0200, Michal Hocko wrote:
> > I am wondering if the folllowing check makes any sense with regarding
> > to rule out PM freeze:
> > 
> >         if ((!pm_nosig_freezing && !pm_freezing) &&
> >             cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
> >                 return true;

Doesn't this mean that if PM freezing and OOM killing race each other,
the system may hang?  Driver PM operation may try to allocate memory
-> triggers OOM -> OOM killer selects an already frozen task ->
nothing happens.  I wonder whether OOM killing and PM operations
should be mutually exclusive at a higher level.  e.g. make OOM killing
always override freezing but let hibernation abort operation before
taking snapshot if OOM killing has happened since the beginning of the
PM operation.

Thanks.

-- 
tejun
