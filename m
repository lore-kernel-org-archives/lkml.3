Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaEVIxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaEVIxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:53:03 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "xen-devel\@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc: "axboe\@kernel.dk" <axboe@kernel.dk>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "jerry.snitselaar\@oracle.com" <jerry.snitselaar@oracle.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Felipe Franciosi <felipe.franciosi@citrix.com>,
        Andrew Jones <drjones@redhat.com>, Ronen Hod <rhod@redhat.com>
Subject: Re: [Xen-devel] Backport request to stable of two performance related fixes for xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com>
	<8738g44wxp.fsf@vitty.brq.redhat.com>
	<87ppj8zsfb.fsf@vitty.brq.redhat.com> <537B2F2C.4080905@citrix.com>
	<87lhtwznhl.fsf@vitty.brq.redhat.com>
	<9F2C4E7DFB7839489C89757A66C5AD625AC66D@AMSPEX01CL03.citrite.net>
Date: Thu, 22 May 2014 10:52:50 +0200
In-Reply-To: <9F2C4E7DFB7839489C89757A66C5AD625AC66D@AMSPEX01CL03.citrite.net>
	(Felipe Franciosi's message of "Tue, 20 May 2014 13:59:05 +0000")
Message-ID: <87k39ew5y5.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Franciosi <felipe.franciosi@citrix.com> writes:

> I had a small side-bar thread with Vitaly discussing the
> comprehensiveness of his measurements and how his tests are being
> conducted. He will report new results as they become available.

I'm back ;-)

In short: I think I was able to find a very 'special' case when this
patch series leads to io performance regression. It is clearly visible
with upstream kernel, no RHEL specifics involved. Now the details.

I compare IO performance with 3 kernel
1) "unpatched_upstream" means unmodified Linus's
  60b5f90d0fac7585f1a43ccdad06787b97eda0ab build

2) "revertall_upstream" means upstream with all patches reverted
  (60b5f90d0fac7585f1a43ccdad06787b97eda0ab + 3 commits reverted:
  427bfe07e6744c058ce6fc4aa187cda96b635539,
  bfe11d6de1c416cea4f3f0f35f864162063ce3fa,
  fbe363c476afe8ec992d3baf682670a4bd1b6ce6)

3) "revokefaonly_upstream" means upstream with "revoke foreign access"
  patch only (60b5f90d0fac7585f1a43ccdad06787b97eda0ab + 2 commits
  revered:
  427bfe07e6744c058ce6fc4aa187cda96b635539,
  bfe11d6de1c416cea4f3f0f35f864162063ce3fa)

I have the following setup:
1) Single-cpu "Intel(R) Xeon(R)CPU W3550 @ 3.07GHz" system, 4 cores
2) No hyper threading, turbo boost, ..
3) Dom0 is running 3.11.10-301.fc20.x86_64 kernel, xen-4.3.2-3.fc20.x86_64
4) Dom0 is pinned to Core0
5) I create 9 clients pinned to (Core1, Core2, Core3, Core1, Core2,
Core3, Core1, Core2, Core3)
6) Clients are identical, the only thing which differs is kernel.

Now the most important part.
1) For each client I create 1G file on tmpfs in dom0
2) I attach these files to clients as e.g. "file:/tmp/img10.img,xvdc,rw"
(no blkback)
3) In clients I see these devices as "blkfront: xvdc: barrier: enabled;
persistent grants: disabled; indirect descriptors: disabled;"

Tests:
I run fio simultaneously on 1 - 9 clients and measure aggregate
throughput. Each test is being run 3 times and average is being taken. I
run tests with different BS (4k, 64k, 512k, 2048k) and different RW
(randread, randrw)
Fio job:
[fio_jobname]
ioengine=libaio
blocksize=<BS>
filename=/dev/xvdc
randrepeat=1
fallocate=none
direct=1
invalidate=0
runtime=20
time_based
rw=<randread|randrw>

Now the results:

rw=randread:
1) 4k (strange): http://hadoop.ru/pubfiles/bug1096909/4k_r.png
2) 64k: http://hadoop.ru/pubfiles/bug1096909/64k_r.png
3) 512k: http://hadoop.ru/pubfiles/bug1096909/512k_r.png
4) 2048k: http://hadoop.ru/pubfiles/bug1096909/2048k_r.png

rw=randrw:
1) 4k (strange): http://hadoop.ru/pubfiles/bug1096909/4k_rw.png
2) 64k: http://hadoop.ru/pubfiles/bug1096909/64k_rw.png
3) 512k: http://hadoop.ru/pubfiles/bug1096909/512k_rw.png
4) 2048k: http://hadoop.ru/pubfiles/bug1096909/2048k_rw.png

In short, 'revertall_upstream' wins everywhere with significant-enough
difference.

P.S. To see the regression such complicated setup is not required, it is
clearly visible even with 1 client. E.g.:

# for q in `seq 1 10`; do fio --minimal --client <client_with_"revertall_upstream"_kernel> test_r.fio | grep READ; done
   READ: io=8674.0MB, aggrb=444086KB/s, minb=444086KB/s, maxb=444086KB/s, mint=20001msec, maxt=20001msec
   READ: io=8626.0MB, aggrb=441607KB/s, minb=441607KB/s, maxb=441607KB/s, mint=20002msec, maxt=20002msec
   READ: io=8620.0MB, aggrb=441277KB/s, minb=441277KB/s, maxb=441277KB/s, mint=20003msec, maxt=20003msec
   READ: io=8522.0MB, aggrb=436304KB/s, minb=436304KB/s, maxb=436304KB/s, mint=20001msec, maxt=20001msec
   READ: io=8218.0MB, aggrb=420698KB/s, minb=420698KB/s, maxb=420698KB/s, mint=20003msec, maxt=20003msec
   READ: io=8374.0MB, aggrb=428705KB/s, minb=428705KB/s, maxb=428705KB/s, mint=20002msec, maxt=20002msec
   READ: io=8198.0MB, aggrb=419653KB/s, minb=419653KB/s, maxb=419653KB/s, mint=20004msec, maxt=20004msec
   READ: io=7586.0MB, aggrb=388306KB/s, minb=388306KB/s, maxb=388306KB/s, mint=20005msec, maxt=20005msec
   READ: io=8512.0MB, aggrb=435749KB/s, minb=435749KB/s, maxb=435749KB/s, mint=20003msec, maxt=20003msec
   READ: io=8524.0MB, aggrb=436319KB/s, minb=436319KB/s, maxb=436319KB/s, mint=20005msec, maxt=20005msec

# for q in `seq 1 10`; do fio --minimal --client <client_with_"unpatched_upstream"_kernel> test_r.fio | grep READ; done
   READ: io=7236.0MB, aggrb=370464KB/s, minb=370464KB/s, maxb=370464KB/s, mint=20001msec, maxt=20001msec
   READ: io=6506.0MB, aggrb=333090KB/s, minb=333090KB/s, maxb=333090KB/s, mint=20001msec, maxt=20001msec
   READ: io=6584.0MB, aggrb=337050KB/s, minb=337050KB/s, maxb=337050KB/s, mint=20003msec, maxt=20003msec
   READ: io=7120.0MB, aggrb=364489KB/s, minb=364489KB/s, maxb=364489KB/s, mint=20003msec, maxt=20003msec
   READ: io=6610.0MB, aggrb=338347KB/s, minb=338347KB/s, maxb=338347KB/s, mint=20005msec, maxt=20005msec
   READ: io=7024.0MB, aggrb=359556KB/s, minb=359556KB/s, maxb=359556KB/s, mint=20004msec, maxt=20004msec
   READ: io=7320.0MB, aggrb=374765KB/s, minb=374765KB/s, maxb=374765KB/s, mint=20001msec, maxt=20001msec
   READ: io=6540.0MB, aggrb=334814KB/s, minb=334814KB/s, maxb=334814KB/s, mint=20002msec, maxt=20002msec
   READ: io=6636.0MB, aggrb=339661KB/s, minb=339661KB/s, maxb=339661KB/s, mint=20006msec, maxt=20006msec
   READ: io=6594.0MB, aggrb=337595KB/s, minb=337595KB/s, maxb=337595KB/s, mint=20001msec, maxt=20001msec

Dumb 'dd' test shows the same:
"revertall_upstream" client:
# time for ntry in `seq 1 100`; do dd if=/dev/xvdc of=/dev/null bs=2048k 2> /dev/null; done

real0m16.262s
user0m0.189s
sys0m7.021s

"unpatched_upstream"
# time for ntry in `seq 1 100`; do dd if=/dev/xvdc of=/dev/null bs=2048k 2> /dev/null; done

real0m19.938s
user0m0.174s
sys0m9.489s

I tried running newer Dom0 (3.14.4-200.fc20.x86_64) but that makes no
difference.

P.P.S. I understand this test differs a lot from what these patches were
supposed to fix and I'm not trying to say 'no' for stable backport, but
I also thinks this test data can be interesting as well.

And thanks, Felipe, for all your hardware hints!

>
> In the meantime, I stand behind that the patches need to be backported and there is a regression if we don't do that.
> Ubuntu has already provided a test kernel with the patches pulled in.  I will test those as soon as I get the chance (hopefully by the end of the week).
> See: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1319003
>
> Felipe
>
>> -----Original Message-----
>> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> Sent: 20 May 2014 12:41
>> To: Roger Pau Monne
>> Cc: Konrad Rzeszutek Wilk; axboe@kernel.dk; Felipe Franciosi;
>> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
>> stable@vger.kernel.org; jerry.snitselaar@oracle.com; xen-
>> devel@lists.xenproject.org
>> Subject: Re: [Xen-devel] Backport request to stable of two performance
>> related fixes for xen-blkfront (3.13 fixes to earlier trees)
>> 
>> Roger Pau Monné <roger.pau@citrix.com> writes:
>> 
>> > On 20/05/14 11:54, Vitaly Kuznetsov wrote:
>> >> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>> >>
>> >>> 1) ramdisks (/dev/ram*) (persistent grants and indirect descriptors
>> >>> disabled)
>> >>
>> >> sorry, there was a typo. persistent grants and indirect descriptors
>> >> are enabled with ramdisks, otherwise such testing won't make any sense.
>> >
>> > I'm not sure how is that possible, from your description I get that
>> > you are using 3.11 on the Dom0, which means blkback has support for
>> > persistent grants and indirect descriptors, but the guest is RHEL7,
>> > that's using the 3.10 kernel AFAICT, and this kernel only has
>> > persistent grants implemented.
>> 
>> RHEL7 kernel is mostly merged with 3.11 in its Xen part, we have indirect
>> descriptors backported.
>> 
>> Actually I tried my tests with upstream (Fedora) kernel and results were
>> similar. I can try comparing e.g. 3.11.10 with 3.12.0 and provide exact
>> measurements.
>> 
>> --
>>   Vitaly
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

-- 
  Vitaly
