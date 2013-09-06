Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3IFSJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:09:35 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55710 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3IFSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:09:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
References: <20130729095109.GB4678@dhcp22.suse.cz>
	<20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
	<51F71DE2.4020102@huawei.com>
	<87ppu0a298.fsf_-_@tw-ebiederman.twitter.com>
	<20130730123120.GA15847@dhcp22.suse.cz>
	<874nbc3sx1.fsf@tw-ebiederman.twitter.com>
	<20130731073726.GC30514@dhcp22.suse.cz> <87zjt2tm9f.fsf@xmission.com>
	<20130801090620.GA5198@dhcp22.suse.cz>
	<20130905095653.GB9702@dhcp22.suse.cz>
Date: Fri, 06 Sep 2013 11:09:21 -0700
In-Reply-To: <20130905095653.GB9702@dhcp22.suse.cz> (Michal Hocko's message of
	"Thu, 5 Sep 2013 11:56:53 +0200")
Message-ID: <87ob85kejy.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18OlMRKo4Y8I6gWhfcp4EyWj/TuwrQq9Zw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michal Hocko <mhocko@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: memcg creates an unkillable task in 3.11-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> It seems that this one fell though the cracks?

Not completely, but it happened just as I was doing my initial triage of
memcg problems and I haven't quite made it back to this.

I have an even nastier memcg hang (without yet an easy reproducer).
During mkdir ext3 can add a page to the page cache with the ext3 journal
transaction lock held.  Normally that isn't a problem but freezing there
stops all writes to that filesystem, and the world stops.

It looks like the only way to avoid that kind of scenario is to move the
the memcg sleep to the edge of userspace, like we do with signals and a
few other things so we can be guaranteed not to increase lock hold
times, when it is avoidable.  I think I saw some similar comments about
the slab limiting.

Eric
