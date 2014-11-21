Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaKUSP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:15:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43458 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaKUSPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:15:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
	<1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
	<20141111140454.GD333@tucsk> <87mw7xd9zt.fsf@x220.int.ebiederm.org>
	<20141112130915.GG333@tucsk> <20141112162254.GB31775@ubuntu-hedt>
	<20141118152156.GA21726@ubuntu-mba51>
	<CAJfpeguuT1V1Pf0iFXRozmeohDH2Jy=p8o=1EnvD_qfB1CTQuA@mail.gmail.com>
	<CAJfpeguctYFkzBPN26=WjOCLTt2mqvouHXqLZ1sRqZngtbw8CQ@mail.gmail.com>
	<20141119140911.GA27009@mail.hallyn.com>
	<20141121164441.GA1730@ubuntu-mba51>
Date: Fri, 21 Nov 2014 12:14:19 -0600
In-Reply-To: <20141121164441.GA1730@ubuntu-mba51> (Seth Forshee's message of
	"Fri, 21 Nov 2014 10:44:41 -0600")
Message-ID: <87ppcgju9w.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+NaaQwt9tSTi9Q7efweV+VDKxnluoSuT8=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seth Forshee <seth.forshee@canonical.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 579 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 2.8 (0.5%), b_tie_ro: 1.93 (0.3%), parse: 1.17 (0.2%),
	extract_message_metadata: 24 (4.1%), get_uri_detail_list: 4.3 (0.7%),
	tests_pri_-1000: 9 (1.5%), tests_pri_-950: 1.67 (0.3%), tests_pri_-900: 1.43
	(0.2%), tests_pri_-400: 35 (6.1%), check_bayes: 34 (5.8%), b_tokenize: 12
	(2.1%), b_tok_get_all: 12 (2.1%), b_comp_prob: 3.1 (0.5%), b_tok_touch_all:
	4.0 (0.7%), b_finish: 0.71 (0.1%), tests_pri_0: 494 (85.3%), tests_pri_500: 6
	(1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of init_user_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> On Wed, Nov 19, 2014 at 03:09:11PM +0100, Serge E. Hallyn wrote:
>> Quoting Miklos Szeredi (miklos@szeredi.hu):
>> > On Wed, Nov 19, 2014 at 9:50 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > > On Tue, Nov 18, 2014 at 4:21 PM, Seth Forshee
>> > > <seth.forshee@canonical.com> wrote:
>> > >>> I asked around a bit, and it turns out there are use cases for nested
>> > >> containers (i.e. a container within a container) where the rootfs for
>> > >> the outer container mounts a filesystem containing the rootfs for the
>> > >> inner container. If that mount is nosuid then suid utilities like ping
>> > >> aren't going to work in the inner container.
>> > >>
>> > >> So since there's a use case for suid in a userns mount and we have what
>> > >> we belive are sufficient protections against using this as a vector to
>> > >> get privileges outside the container, I'm planning to move ahead without
>> > >> the MNT_NOSUID restriction. Any objections?
>> > >
>> > > In the general case how'd we prevent suid executable being tricked to
>> > > do something it shouldn't do by unprivileged mounting into sensitive
>> > > places (i.e. config files) inside the container?
>> 
>> The design of the namespaces would prevent that.  You cannot manipulate your
>> mounts namespace unless you own it.  You cannot manipulate the mounts namespace
>> for a task whose user namespace you do not own.  If you can, for instance,
>> bind mount $HOME/shadow onto /etc/shadow, then you already own your user
>> namespace and are root there, so any suid-root program which you mount through
>> fuse will only subjegate your own namespace.  Any task which running in the
>> parent user-ns (and therefore parent mount-ns) will not see your bind mount.
>> 
>> > > Allowing SUID looks like a slippery slope to me.  And there are plenty
>> > > of solutions to the "ping" problem, AFAICS, that don't involve the
>> > > suid bit.
>> > 
>> > ping isn't even suid on my system, it has security.capability xattr instead.
>> 
>> security.capability xattrs that will have the exact same concerns wrt
>> confusion through bind mounts as suid.
>> 
>> > Please just get rid of SUID/SGID.  It's a legacy, it's a hack, not
>> > worth the complexity and potential problems arising from that
>> > complexity.
>> 
>> Oh boy, I don't know which side to sit on here :)  I'm all for replacing
>> suid with some use of file capabilities, but realistically there are reasons
>> why that hasn't happened more widely than it has - tar, package managers,
>> cpio, nfs, etc.
>
> Miklos: I we're all generally in agreement here that suid/sgid is not
> the best solution, but as Serge points out we are unfortunately not yet
> in a place where it can be completely dropped in favor of capabilities.
> In light of this can I convince you to reconsider your position?

Regardless of what fuse does user namespaces must support mounting
filesystems that have the setuid and setgid bits set.  Likewise we need
to handle capabilities.

There is a parallel bit of work to the fuse patches that I think at this
point should be completed first.

- Add s_user_ns to struct super.  So we can have filesystems whose
  labels are not interpreted at a global scope.

- Tweak the file capability code to look at s_user_ns and treat it
  properly.

- Tweak the lsms to look at s_user_ns and ignore security labels that
  don't come from init_user_ns.  (The lsms at their discrection can
  be more trusting but the default should be for them to ignore those
  labels).

- Tweak the security checks to allow setting file capabilities and
  other security xattrs if we have the appropriate capabilities in
  s_user_ns.

- Update tmpfs and ramfs to set s_user_ns when being mounted.


When those bits are done we can tweak the fuse patches to also set
s_user_ns.

As for MNT_NO_SUID if fuse wants to enforce that in some way.  I don't
particularly care, but I don't think that makes sense as a vfs property.

Eric
