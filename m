Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaHIOOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:14:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaHIOOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:14:19 -0400
Date: Sat, 9 Aug 2014 07:04:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Oleg Drokin <green@linuxhacker.ru>, Evgeny Budilovsky <budevg@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lai Siyao <lai.siyao@intel.com>
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu
 protected current->real_parent field
Message-ID: <20140809140426.GA20995@kroah.com>
References: <87k36ltoob.fsf@gmail.com>
 <20140806214216.GA16530@kroah.com>
 <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com>
 <20140808034951.GA6626@kroah.com>
 <DFF36154-06AC-4D7E-87F5-259B73CB059B@linuxhacker.ru>
 <20140808044246.GA3084@kroah.com>
 <1FE03450-A256-4A18-85AB-6332A28E3EF5@linuxhacker.ru>
 <20140808053246.GA13588@kroah.com>
 <CA+a=Yy4SqXSe667DkU3KA80tAt5D=KG-9mfccvEwtJzuFr6vBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy4SqXSe667DkU3KA80tAt5D=KG-9mfccvEwtJzuFr6vBA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 07:05:46PM +0800, Peng Tao wrote:
> On Fri, Aug 8, 2014 at 1:32 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Fri, Aug 08, 2014 at 01:06:15AM -0400, Oleg Drokin wrote:
> >>
> >> On Aug 8, 2014, at 12:42 AM, Greg Kroah-Hartman wrote:
> >>
> >> > On Fri, Aug 08, 2014 at 12:03:20AM -0400, Oleg Drokin wrote:
> >> >> Hello!
> >> >>
> >> >> On Aug 7, 2014, at 11:49 PM, Greg Kroah-Hartman wrote:
> >> >>>>
> >> >>>> This is not a critical bug and in the worst case the code here may
> >> >>>> cause miss of statistics counter increase.
> >> >>>> This is why I think it is not worth to backport the patch at all.
> >> >>> You are right, and if this is just for some random "statistics" file,
> >> >>> can we just delete the whole function?
> >> >>
> >> >> I hope not!
> >> >> This is used all around the client to tally up various operations executed counts.
> >> > Why would you do that?  Why would they care?
> >>
> >> We would do that to provide information on the client operations performed.
> >> They would care because they are interested in what particular clients might be doing.
> >>
> >> >> The statistic is then used by various userspace monitoring tools.
> >> > Why not use the in-kernel monitoring tools instead of creating your own?
> >> > What does userspace do with that information?
> >>
> >> We don't really control the userspace tools. People write tools to suit their needs
> >> to monitor loads, see odd things the end users are doing or possibly for some
> >> debugging even.
> >> Correlating these numbers with what server sees also proves useful at times
> >> (write combining for example).
> >>
> >> Here's a sample of output of a recently mounted client that I poked on a bit (the lines starting with # are my comments):
> >> # cat /proc/fs/lustre/llite/lustre-ffff88008dde27f0/stats
> >> snapshot_time             1407473168.466102 secs.usecs
> >> read_bytes                1 samples [bytes] 0 0 0
> >> write_bytes               4 samples [bytes] 2 7 19
> >> osc_write                 4 samples [bytes] 2 7 19
> >> # The bytes counts show you minimum, maximum of writes seen and total number of bytes read-written.
> >> # Lustre (and many other network filesystems) is very sensitive to small IO, esp. reads so it's good
> >> # to know if you have a lot of it.
> >> open                      6 samples [regs]
> >> # The "regs" type just shows you how many of given type operations were performed since last statistic reset.
> >> # Frequently that allows people to guess where does high load come from on a particular client when
> >> # it's otherwise not obvious because not a lot of cpu is used.
> >> # Some operations are heavier than others too.
> >> close                     6 samples [regs]
> >> readdir                   4 samples [regs]
> >> setattr                   1 samples [regs]
> >> truncate                  4 samples [regs]
> >> getattr                   7 samples [regs]
> >> create                    1 samples [regs]
> >> alloc_inode               1 samples [regs]
> >> getxattr                  8 samples [regs]
> >> inode_permission          28 samples [regs]
> >>
> >> As more operations types are seen the list grows.
> >> Then there are also specific stats for readahead (data and metadata) so that interested people can make informed
> >> decisions on the tuning there should they be unsatisfied with default settings.
> >>
> >> I am not sure there's a similar mechanism in the kernel already that
> >> would allow us to get this sort of data easily all in one place?
> >
> > perf should show you this, if not, please add the functionality there.
> > A filesystem is not the place to have performance monitoring code, this
> > needs to be removed before it can be moved out of staging.  Please work
> > with the trace/perf developers on this if there is something lacking
> > there.
> >
> nfs and nfsd track rpc ops statistics and export them via
> /proc/self/mountstats, e.g.,
> 
> device 192.168.214.141:/d9691564-432b-11e2-8e5d-8b7acf882df3 mounted
> on /mnt/pnfsd with fstype nfs4 statvers=1.1
>         opts: rw,vers=4.1,rsize=262144,wsize=262144,namlen=255,acregmin=3,acregmax=60,acdirmin=30,acdirmax=60,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=192.168.214.128,local_lock=none
>         age:    15426
>         impl_id:        name='',domain='',date='0,0'
>         caps:   caps=0x3ffff,wtmult=512,dtsize=32768,bsize=0,namlen=255
>         nfsv4:  bm0=0xfdffbfff,bm1=0x40f9be3e,bm2=0x803,acl=0x3,sessions
>         sec:    flavor=1,pseudoflavor=1
>         events: 82474 12159573 9527 109202 7574 10119 16289648 3634869
> 10938 108551 2084272 182492 13646 7700 52594 60832 8829 48985 0 6564
> 1459053 66 0 0 0 289315 376376
>         bytes:  11526471786 9942294760 3280371712 3278274560
> 14578366831 11710126268 2782400 2084272
>         RPC iostats version: 1.0  p/v: 100003/4 (nfs)
>         xprt:   tcp 859 0 2 0 12 408031 407999 29 2169734 0 32 2496 310753
>         per-op statistics
>                 NULL: 0 0 0 0 0 0 0 0
>                 READ: 289327 289326 0 35877640 14615129136 63609 1800007 1893161
>                WRITE: 376352 376360 0 11759732976 51184768 6698277
> 2246445 8978314
>               COMMIT: 3076 3076 0 381424 393728 1827 15450 17329
>                 OPEN: 24926 24926 0 7329252 8968144 1373312 1794621 3169378
> <snip...>
> 
> Why Lustre cannot do similar things?

Because maybe these stats preceed the introduction of perf and other
tracing/debug tools?  I don't know, it's really low down on the list of
reasons why lustre can't be merged out of staging at the moment, you all
have much bigger issues to address first.

thanks,

greg k-h
