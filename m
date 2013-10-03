Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3JCMCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:02:24 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:50543 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753913Ab3JCMCX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:02:23 -0400
X-ASG-Debug-ID: 1380801738-053ea958903d5350001-xx1T2L
X-Barracuda-Envelope-From: osengineering@stec-inc.com
From: OS Engineering <osengineering@stec-inc.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Ramprasad C <ramprasad.ch@gmail.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OS Engineering <osengineering@stec-inc.com>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>
Subject: RE: [PATCH 14/14] skd: remove skd_bio code
Thread-Topic: [PATCH 14/14] skd: remove skd_bio code
X-ASG-Orig-Subj: RE: [PATCH 14/14] skd: remove skd_bio code
Thread-Index: AQHOvqg7Ib2lm7LNhUOSOtfjPPQNiZngfzoAgAJbSbA=
Date: Thu, 3 Oct 2013 12:00:56 +0000
Message-ID: <24CA9A5C93173F48A9E3313B866A7C280F2C58@MYMBX3.stec-inc.ad>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
 <1380547556-17719-15-git-send-email-b.zolnierkie@samsung.com>
 <CACbH579bNVcSMiWKexxNG=E3BXF1yoEDttHf3A94ZQyNpdM7Cg@mail.gmail.com>
 <3898812.vf7OgV5Y6P@amdc1032>
In-Reply-To: <3898812.vf7OgV5Y6P@amdc1032>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.20.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[172.30.8.22]
X-Barracuda-Start-Time: 1380801738
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141140
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Tuesday, October 01, 2013 10:01 PM
> To: Ramprasad C
> Cc: axboe@kernel.dk; Akhil Bhansali; jmoyer@redhat.com;
> kyungmin.park@samsung.com; linux-kernel@vger.kernel.org; OS
> Engineering; Amit Phansalkar
> Subject: Re: [PATCH 14/14] skd: remove skd_bio code
> 
> 
> Hi Ramprasad,
> 
> On Tuesday, October 01, 2013 06:46:00 PM Ramprasad C wrote:
> > Hi Bartlomiej,
> >
> > Thank for your contributions to skd driver.
> >
> > The reason why skd driver has two code paths is:-
> > 1. For some workloads, Bio code path (skd_bio=1) performs better as
> > compared to default code, like random r/w, high queue depths, direct
> i/o
> > etc. In Bio code path, driver bypasses linux block elevator +
> scheduler
> > layers and 'struct bio' comes directly to driver through
> make_request_fn().
> 
> Have you tried using "noop" I/O scheduler to alleviate the issue?
> 
> You need the kernel compiled with CONFIG_IOSCHED_NOOP=y (it is enabled
> by
> default) and then do i.e. "echo noop > /sys/block/skd0/queue/scheduler"
> to
> enable "noop" I/O scheduler for the skd0 block device.
> 
> > 2. For some workloads like buffered mode (app) i/o, the default code
> path
> > performs much better. Hence, both the code paths are kept with module
> > parameter. We would prefer to have both code paths.
> 
> It would be very useful to see some numbers for skd_bio=1 and skd_bio=0
> (with "noop" I/O scheduler enabled) for the affected workloads to see
> what
> kind of improvement is offered by skd_bio=1.
> 
> If the block layer queuing code is a problem even with "noop" I/O
> scheduler
> it would be much better try to identify and fix (if possible) the
> problem
> parts in the generic block layer code. This would benefit all SSD
> hardware
> used on Linux not only the one supported by skd driver.
> 
> Also it is very inflexible to require the driver re-load just to
> optimize
> it for some workload. I believe that a better solution (runtime
> selection
> of the mode of operation at the block layer level) can be provided if
> really necessary.
> 

Hi Bartlomiej,

There was performance gap with noop too. However, for noop with nomerge=1 and rotation=0, the performance difference is marginal.
We feel the skd_bio=1 code path can be removed and can keep the single (default) code path in the driver.

Regards,
Ramprasad


> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> > Regards,
> > Ramprasad
> >
> >
> >
> > On Mon, Sep 30, 2013 at 6:55 PM, Bartlomiej Zolnierkiewicz <
> > b.zolnierkie@samsung.com> wrote:
> >
> > > skd_bio feature adds a possibility to use the internal bio list to
> process
> > > requests instead of using the normal block layer queueing
> functionality.
> > > Its potential advantages are unclear and if there are any it is
> better to
> > > identify and fix the block layer code deficiences instead. Moreover
> it
> > > introduces separate code-paths through the whole driver which are
> difficult
> > > to test properly and maintain in the long-term. Since it is
> currently not
> > > used unless explicitly enabled by module parameter just remove it.
> > >
> > > Cc: Akhil Bhansali <abhansali@stec-inc.com>
> > > Cc: Jeff Moyer <jmoyer@redhat.com>
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  drivers/block/skd_main.c | 605
> > > ++++++-----------------------------------------
> > >  1 file changed, 76 insertions(+), 529 deletions(-)

