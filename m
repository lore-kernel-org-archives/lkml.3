Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040AbaGYRe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:34:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35991 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839AbaGYRe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:34:56 -0400
Date: Fri, 25 Jul 2014 17:34:43 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
Cc: "Richard Weinberger (richard@nod.at)" <richard@nod.at>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "Oleg Nesterov (oleg@redhat.com)" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Vasily Kulikov (segoon@openwall.com)" <segoon@openwall.com>
Subject: Re: [RFC]Pid conversion between pid namespace
Message-ID: <20140725173443.GH31507@ubuntumail>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140715041628.GL1132@ubuntumail>
 <5871495633F38949900D2BF2DC04883E569892@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5871495633F38949900D2BF2DC04883E569892@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> Hi,
> 
> > -----Original Message-----
> > From: Serge Hallyn [mailto:serge.hallyn@ubuntu.com]
> > Sent: Tuesday, July 15, 2014 12:16 PM
> > To: Chen, Hanxiao/陈 晗霄
> > Subject: Re: [RFC]Pid conversion between pid namespace
> > >     A-2) syscall pid_t getnspid(pid_t query_pid, pid_t observer_pid)
> > >     pros:
> > >         - ns procfs free, easy to use.
> > >         We could get rid of mounted ns procfs.
> > >
> > >     cons:
> > >         - may find multiple results in nested ns.
> > >           We wished the new API could tell us the exact answer.
> > >           But if getnspid return more than one results will bring trouble to admins,
> > 
> > (See below for more, but) the question being posed to getnspid has precisely
> > one answer.
> > 
> > >           they had to make another decision.
> > >           Or we marked the deepest level for translation as prerequisite.
> > >
> > >         -based on current pidns, no reference ns.
> > 
> > Hm, no.  The intent here was that
> > 
> > 	observer_pid would be in current ns
> > 	query_pid would be in observer_pid's ns.
> > 
> > So this would be ideal for "I got a pid in a logfile created by rsyslog in
> > a nested contaner, what is the logged pid in my pidns."
> > 
> > Taking a set of tasks (like a container with nesting) and bulding a tree
> > of all pids shouldn't be too difficult either.  Start with the init pid,
> > call getnspid($pid, $init_pid) for every $pid in the container;  to figure
> > out whether any $pid is itself a nested init_pid, we can compare the
> > /proc/$$/ns/pid, as well as look at getnspid($pid, $pid).
> I'm a little confused in this section:
> 
> Ex:
>     init_pid_ns    ns1         ns2
> t1  2
> t2   `- 3          1 
> t3       `- 4      `- 5        1
> t4           `-6       `-8      `-9
> t5             `-10       `-9      `-10
> 
> For getnspid($pid, $init_pid),
> Does init_pid means container's init_pid such as 3 for t2?

Right, if you're in init_pid_ns and making the query, then
you'd pass 3.

> In nested containers, does this syscall work as:
> getnspid(9, 4) -> (6, 8, 9) 

No, assuming the querying task is in init_pid_ns,
getnspid(9, 4) would return 6.

4 is the observer pid given in the querier's own pidns, so
it refers to t3.  9 is the pid being queried, in the oberver's
pidns, so it revers to t4.  The result is, the pid in our own
pidns.

Does that help clarify at all?  I'm not sure whether the problem is that
I didn't explain well enough from the start, or whether this just shows
that the API is one only its mother could love :)

-serge
