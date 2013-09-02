Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab3IBOBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:01:34 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41940 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab3IBOBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:01:33 -0400
Date: Mon, 2 Sep 2013 17:00:15 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130902140015.GB2368@swordfish.minsk.epam.com>
References: <20130820111426.GA27828@swordfish.datadirectnet.com>
 <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
 <20130821153957.GA2969@swordfish.minsk.epam.com>
 <20130830230402.GA14760@somewhere>
 <20130902122845.GA2457@swordfish.minsk.epam.com>
 <20130902130744.GB2378@somewhere>
 <20130902135033.GA1686@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902135033.GA1686@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/02/13 15:50), Stanislaw Gruszka wrote:
> Date: Mon, 2 Sep 2013 15:50:34 +0200
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> To: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Ingo Molnar
>  <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E.
>  McKenney" <paulmck@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
>  linux-kernel@vger.kernel.org
> Subject: Re: [sched next] overflowed cpu time for kernel threads in
>  /proc/PID/stat
> User-Agent: Mutt/1.5.21 (2010-09-15)
> 
> On Mon, Sep 02, 2013 at 03:07:45PM +0200, Frederic Weisbecker wrote:
> > > Hope this may help.
> > > I've added a silly check to make sure that `stime < rtime'
> > > 
> > > @@ -579,6 +582,10 @@ static void cputime_adjust(struct task_cputime *curr,
> > >         if (total) {
> > >                 stime = scale_stime((__force u64)stime,
> > >                                     (__force u64)rtime, (__force u64)total);
> > > +               if (stime > rtime) {
> > > +                       printk(KERN_ERR "Ooops: stime:%llu rtime:%llu\n", stime, rtime);
> > > +                       WARN_ON(1);
> > > +               }
> > >                 utime = rtime - stime;
> > >         } else {
> > >                 stime = rtime;
> [snip]
> 
> > Thanks a lot Sergey for testing this further!
> > 
> > Interesting results, so rtime is always one or two units off stime after scaling.
> > Stanislaw made the scaling code with Linus and he has a better idea on the math guts
> > here.
> 
> I don't think this is scale issue, but rather at scale_stime() input
> stime is already bigger then rtime. Sergey, could you verify that
> by adding check before scale_stime() ?
> 

usually stime < rtime.
this is what scale_stime() gets as input:

[ 1291.409566] stime:3790580815 rtime:4344293130 total:3790580815
[ 1300.484675] stime:3966526699 rtime:4316110636 total:3966526699
[ 1309.548850] stime:4016453845 rtime:4369061182 total:4016453845
[ 1315.597880] stime:4055256777 rtime:4409603756 total:4055256777
[ 1315.598340] stime:4004230541 rtime:4571167362 total:4004230541
[ 1318.623774] stime:4072651687 rtime:4427641260 total:4072651687
[ 1318.624194] stime:3307672697 rtime:4359433252 total:3307672697
[ 1321.661950] stime:4073588267 rtime:4644946914 total:4073588267
[ 1324.691457] stime:4105876887 rtime:4462631018 total:4105876887
[ 1327.722074] stime:3375231967 rtime:4439900096 total:3375231967
[ 1333.757482] stime:4156087279 rtime:4514990216 total:4156087279
[ 1333.757755] stime:3427423145 rtime:4504337498 total:3427423145
[ 1333.758080] stime:4180115893 rtime:4758073724 total:4180115893
[ 1339.813117] stime:3465843945 rtime:4554325330 total:3465843945
[ 1342.845746] stime:4204665773 rtime:4565346324 total:4204665773
[ 1345.888570] stime:3497346343 rtime:4592210094 total:3497346343
[ 1348.922371] stime:4348957782 rtime:4935439460 total:4348957782
[ 1351.950096] stime:4362056506 rtime:4949617939 total:4362056506
[ 1361.021453] stime:4295785738 rtime:4661661137 total:4295785738
[ 1361.022000] stime:4458897246 rtime:5051395981 total:4458897246
[ 1364.050371] stime:4311972683 rtime:4678581654 total:4311972683
[ 1364.050765] stime:4479087426 rtime:5072949454 total:4479087426
[ 1367.076973] stime:4499465526 rtime:5094687861 total:4499465526
[ 1370.099987] stime:4343775870 rtime:4712036053 total:4343775870
[ 1373.125650] stime:4359154163 rtime:4727095545 total:4359154163
[ 1373.126009] stime:4552630150 rtime:5150626456 total:4552630150
[ 1376.148541] stime:4374640011 rtime:4743265121 total:4374640011
[ 1379.177031] stime:3732027459 rtime:4887067184 total:3732027459
[ 1382.220666] stime:4404735122 rtime:4774829507 total:4404735122
[ 1385.246696] stime:4420289930 rtime:4790957716 total:4420289930
[ 1385.247197] stime:4649961982 rtime:5253432805 total:4649961982
[ 1388.269661] stime:4433706951 rtime:4804365472 total:4433706951
[ 1388.270078] stime:3783514895 rtime:4952742424 total:3783514895
[ 1391.299533] stime:4449952651 rtime:4821791998 total:4449952651
[ 1394.329016] stime:4463714342 rtime:4836891922 total:4463714342

	-ss
