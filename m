Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaKGQZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:25:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39193 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaKGQZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:25:37 -0500
To: Chris Friesen <chris.friesen@windriver.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>
	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com>
Date: Fri, 07 Nov 2014 11:25:25 -0500
In-Reply-To: <545C5A1B.9020206@windriver.com> (Chris Friesen's message of
	"Thu, 6 Nov 2014 23:35:23 -0600")
Message-ID: <yq1bnoj9dvu.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:

Chris,

Chris> Also, I think it's wrong for filesystems and userspace to use it
Chris> for alignment.  In E.4 and E.5 in the "sbc3r25.pdf" doc, it looks
Chris> like they use the optimal granularity field for alignment, not
Chris> the optimal transfer length.

The original rationale behind the OTLG and OTL values was to be able to
express stripe chunk size and stripe width. And to encourage aligned,
full stripe writes but nothing bigger than that. Obviously the wording
went through the usual standards body process to be vague/generic enough
to be used for anything. It has changed several times since sbc3r25,
btw.

The kernel really isn't using io_opt. The value is merely stacked and
communicated to userspace. The reason the partitioning tools blow up
with weird values is that they try to align partitions beginnings to the
stripe width. Which is the right thing to do as far as I'm concerned.

I have worked with many, many partners in the storage industry to make
sure they report sensible values in the Block Limits VPD. I have no
reason to believe that the SAS drive issue in question is anything but a
simple typo. I know there was a bug open with Seagate. I assume it has
been fixed in their latest firmware. To my knowledge it is not a problem
in any of their other drive models. Certainly isn't in any of the ones
we are shipping.

The unfortunate thing with disk drives is that firmware updates are much
harder to deal with. And you rarely end up having access to an updated
firmware unless your drive was procured through a vendor like Dell, HP
or Oracle. That's why I originally opted to quirk this model in
Linux. Otherwise I would just have said "update your firmware".

If we had devices from many different vendors showing up with values
that constantly threw off our tooling I would have more reason to be
concerned. But we haven't. And this code has been in the kernel since
2.6.32 or so.

-- 
Martin K. Petersen	Oracle Linux Engineering
