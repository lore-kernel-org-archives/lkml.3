Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaHNOlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:41:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbaHNOle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:41:34 -0400
Date: Thu, 14 Aug 2014 16:39:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
	seqlock
Message-ID: <20140814143902.GA29052@redhat.com>
References: <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814004318.GA2582@lerouge> <53EC176D.6080201@redhat.com> <CAFTL4hwfNyQPMfpca-=Ou7WoPjB6sE_7BVAcQrVDkBjjPVmPRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hwfNyQPMfpca-=Ou7WoPjB6sE_7BVAcQrVDkBjjPVmPRw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Frederic Weisbecker wrote:
>
> 2014-08-14 3:57 GMT+02:00 Rik van Riel <riel@redhat.com>:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > On 08/13/2014 08:43 PM, Frederic Weisbecker wrote:
> >> On Wed, Aug 13, 2014 at 05:03:24PM -0400, Rik van Riel wrote:
> >>
> >> I'm worried about such lockless solution based on RCU or read
> >> seqcount because we lose the guarantee that an update is
> >> immediately visible by all subsequent readers.
> >>
> >> Say CPU 0 updates the thread time and both CPU 1 and CPU 2 right
> >> after that call clock_gettime(), with the spinlock we were
> >> guaranteed to see the new update. Now with a pure seqlock read
> >> approach, we guarantee a read sequence coherency but we don't
> >> guarantee the freshest update result.
> >>
> >> So that looks like a source of non monotonic results.
> >
> > Which update are you worried about, specifically?
> >
> > The seq_write_lock to update the usage stat in p->signal will lock out
> > the seqlock read side used to check those results.
> >
> > Is there another kind of thing read by cpu_clock_sample_group that you
> > believe is not excluded by the seq_lock?
>
> I mean the read side doesn't use a lock with seqlocks. It's only made
> of barriers and sequence numbers to ensure the reader doesn't read
> some half-complete update. But other than that it can as well see the
> update n - 1 since barriers don't enforce latest results.

Yes, sure, read_seqcount_begin/read_seqcount_retry "right after"
write_seqcount_begin-update-write_seqcount_begin can miss "update" part
along with ->sequence modifications.

But I still can't understand how this can lead to non-monotonic results,
could you spell?

Oleg.

