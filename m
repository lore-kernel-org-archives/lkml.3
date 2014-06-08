Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaFHD06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 23:26:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56026 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaFHD05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 23:26:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>
References: <5386D58D.2080809@1h.com> <87tx88nbko.fsf@x220.int.ebiederm.org>
	<53870EAA.4060101@1h.com> <20140529153232.GB9714@ubuntumail>
	<538DFF72.7000209@parallels.com> <20140603172631.GL9714@ubuntumail>
	<8738flkhf0.fsf@x220.int.ebiederm.org>
	<1402177144.2236.26.camel@dabdike.int.hansenpartnership.com>
Date: Sat, 07 Jun 2014 20:25:46 -0700
In-Reply-To: <1402177144.2236.26.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Sat, 07 Jun 2014 14:39:04 -0700")
Message-ID: <87vbsc6q11.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+iSec+B5F3/6d871rMxJv4v8LCSFM88TU=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;James Bottomley <James.Bottomley@HansenPartnership.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Per-user namespace process accounting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Tue, 2014-06-03 at 10:54 -0700, Eric W. Biederman wrote:
>> 
>> 90% of that work is already done.
>> 
>> As long as we don't plan to support XFS (as it XFS likes to expose it's
>> implementation details to userspace) it should be quite straight
>> forward.
>
> Any implementation which doesn't support XFS is unviable from a distro
> point of view.  The whole reason we're fighting to get USER_NS enabled
> in distros goes back to lack of XFS support (they basically refused to
> turn it on until it wasn't a choice between XFS and USER_NS).  If we put
> them in a position where they choose a namespace feature or XFS, they'll
> choose XFS.

This isn't the same dicotomy.  This is a simple case of not being able
to use XFS mounted inside of a user namespace.  Which does not cause any
regression from the current use cases.  The previous case was that XFS
would not build at all.

There were valid technical reasons but part of the reason the XFS
conversion took so long was my social engineering the distro's to not
enable the latest bling until there was a chance for the initial crop of
bugs to be fixed.

> XFS developers aren't unreasonable ... they'll help if we ask.  I mean
> it was them who eventually helped us get USER_NS turned on in the first
> place.

Fair enough.  But XFS is not the place to start.

For most filesystems the only really hard part is finding the handful of
places where we actually need some form of error handling when on disk
uids don't map to in core kuids.  Which ultimately should wind up with
maybe a 20 line patch for most filesystems.

For XFS there are two large obstacles to overcome. 

- XFS journal replay does not work when the XFS filesystem is moved from
  a host with one combination of wordsize and endianness to a host with
  a different combination of wordsize and edianness.  This makes XFS a
  bad choice of a filesystem to move between hosts in a sparse file.
  Every other filesystem in the kernel handles this better.

- The XFS code base has a large the largest number of any ioctls of any
  filesystem in the linux kernel.  This increases the amount of code
  that has to be converted.  Combine that with the fact that the XFS
  developers chose to convert from kuids and kgids at the VFS<->FS layer
  instead of at the FS<->disk layer it becomes quite easy to miss
  changing code in an ioctl or a quota check by accident.  Which all
  adds up to the fact that converting XFS to be mountable with a non 1-1
  mapping of filesystem uids and system kuids is going to be a lot more
  than a simple 20 line patch.

All of that said what becomes attractive about this approach is that it
gets us to the point where people can ask questions about mounting
normal filesystems unprivileged and the entire reason it won't be
allowed are (no block devices to mount from) and concern that the
filesystem error handling code is not sufficient to ward off evil users
that create bad filesystem images.

Eric


