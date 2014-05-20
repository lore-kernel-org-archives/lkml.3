Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaETOCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:02:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbaETOB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:01:59 -0400
Date: Tue, 20 May 2014 10:01:46 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, arozansk@redhat.com,
        serge@hallyn.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [PATCH V3 0/6] namespaces: log namespaces per task
Message-ID: <20140520140146.GA8079@madcap2.tricolour.ca>
References: <cover.1400271129.git.rgb@redhat.com>
 <1400593754.15733.4.camel@flatline.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400593754.15733.4.camel@flatline.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/20, Eric Paris wrote:
> On Tue, 2014-05-20 at 09:12 -0400, Richard Guy Briggs wrote:
> > The purpose is to track namespaces in use by logged processes from the
> > perspective of init_*_ns.
> > 
> > 1/6 defines a function to generate them and assigns them.
> > 
> > Use a serial number per namespace (unique across one boot of one kernel)
> > instead of the inode number (which is claimed to have had the right to change
> > reserved and is not necessarily unique if there is more than one proc fs).  It
> > could be argued that the inode numbers have now become a defacto interface and
> > can't change now, but I'm proposing this approach to see if this helps address
> > some of the objections to the earlier patchset.
> > 
> > 2/6 adds access functions to get to the serial numbers in a similar way to
> > inode access for namespace proc operations.
> > 
> > 3/6 implements, as suggested by Serge Hallyn, making these serial numbers
> > available in /proc/self/ns/{ipc,mnt,net,pid,user,uts}_snum.  I chose "snum"
> > instead of "seq" for consistency with inum and there are a number of other uses
> > of "seq" in the namespace code.
> > 
> > 4/6 exposes proc's ns entries structure which lists a number of useful
> > operations per namespace type for other subsystems to use.
> > 
> > 5/6 provides an example of usage for audit_log_task_info() which is used by
> > syscall audits, among others.  audit_log_task() and audit_common_recv_message()
> > would be other potential use cases.
> > 
> > Proposed output format:
> > This differs slightly from Aristeu's patch because of the label conflict with
> > "pid=" due to including it in existing records rather than it being a seperate
> > record.  The serial numbers are printed in hex.
> > 	type=SYSCALL msg=audit(1399651071.433:72): arch=c000003e syscall=272 success=yes exit=0 a0=40000000 a1=ffffffffffffffff a2=0 a3=22 items=0 ppid=1 pid=483 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="(t-daemon)" exe="/usr/lib/systemd/systemd" netns=97 utsns=2 ipcns=1 pidns=4 userns=3 mntns=5 subj=system_u:system_r:init_t:s0 key=(null)
> 
> I'm undecided if I'd rather see this as a separate NS_INFO record type.
> It would mean we could filter them out of the logs...

I don't have a strong opinion either way.  Steve G.'s opinion would be
helpful here.

> Do we print out lots of pidns=0 for tasks not in a newly created NS?  Do
> we want to?

There is no "pidns=0", but I understand your point.  This would come
back to Steve G.'s point about disappearing fields, and the value of
having it as a seperate record that could be filtered.

> > 6/6 tracks the creation and deletion of of namespaces, listing the type of
> > namespace instance, related namespace id if there is one and the newly minted
> > serial number.
> > 
> > Proposed output format:
> > 	type=NS_INIT msg=audit(1400217435.706:94): pid=524 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:mount_t:s0 type=20000 old_snum=0 snum=a1 res=1
> 
> I'd love to be able to grep for netns=20 and find both the NS_INIT and
> the SYSCALL/NS_INFO records, instead of having them named different
> things.  So basically I think you want to translate the type= into a
> string for the old_X= and X=...

That actually makes a bit more sense, and we could do away with the
"type=" field since the "Xns=" fields are self-describing.


Any hints on the timing issues mentioned in one of the notes?  I'm
missing initial mntns and netns messages.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
