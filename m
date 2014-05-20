Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaETJdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaETJdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:33:04 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, xen-devel@lists.xenproject.org,
        felipe.franciosi@citrix.com, roger.pau@citrix.com,
        jerry.snitselaar@oracle.com, axboe@kernel.dk
Subject: Re: [Xen-devel] Backport request to stable of two performance related fixes for xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com>
Date: Tue, 20 May 2014 11:32:50 +0200
In-Reply-To: <20140514191122.GA7659@phenom.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Wed, 14 May 2014 15:11:22 -0400")
Message-ID: <8738g44wxp.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> Hey Greg
>
> This email is in regards to backporting two patches to stable that
> fall under the 'performance' rule:
>
>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6
>
> I've copied Jerry - the maintainer of the Oracle's kernel. I don't have
> the emails of the other distros maintainers but the bugs associated with it are:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1096909
> (RHEL7)

I was doing tests with RHEL7 kernel and these patches and unfortunately
I see huge performance degradation in some workloads.

I'm in the middle of my testing now but here are some intermediate
results. 
Test environment:
Fedora-20, xen-4.3.2-2.fc20.x86_64, 3.11.10-301.fc20.x86_64
I do testing with 1-9 RHEL7 PVHVM guests with:
1) Unmodified RHEL7 kernel
2) Only fbe363c476afe8ec992d3baf682670a4bd1b6ce6 applied (revoke foreign
access)
3) Both fbe363c476afe8ec992d3baf682670a4bd1b6ce6 and
bfe11d6de1c416cea4f3f0f35f864162063ce3fa
(actually 427bfe07e6744c058ce6fc4aa187cda96b635539 is required as well
to make build happy, I suggest we backport that to stable as well)

Storage devices are:
1) ramdisks (/dev/ram*) (persistent grants and indirect descriptors disabled)
2) /tmp/img*.img on tmpfs (persistent grants and indirect descriptors disabled)

Test itself: direct random read with bs=2048k (using fio). (Actually
'dd', 'read/write access', ... show same results)

fio test file:
[fio_read]
ioengine=libaio
blocksize=2048k
rw=randread
filename=/dev/xvdc
randrepeat=1
fallocate=none
direct=1
invalidate=0
runtime=20
time_based

I run fio simultaneously and sum up the result. So, results are:
1) ramdisks: http://hadoop.ru/pubfiles/b1096909_3.11.10_ramdisk.png
2) tmpfiles: http://hadoop.ru/pubfiles/b1096909_3.11.10_tmpfile.png

In few words: patch series has (almost) no effect when persistent grants
are enabled (that was expected) and gives me performance regression when
persistent grants are disabled (that wasn't expected).

My thoughts are: it seems fbe363c476afe8ec992d3baf682670a4bd1b6ce6
brings performance regression in some cases (at least when persistent
grants are disabled). My guess atm is that gnttab_end_foreign_access()
(gnttab_end_foreign_access_ref_v1() is being used here) is guilty, for
some reason it is looping for some
time. bfe11d6de1c416cea4f3f0f35f864162063ce3fa really brings performance
improvement over fbe363c476afe8ec992d3baf682670a4bd1b6ce6 but whole
series still brings regression.

I would be glad to hear what could be wrong with my testing in case I'm
the only one who sees such behavior. Any other pointers are more than
welcome and please feel free to ask for any additional
info/testing/whatever from me.

> https://bugs.launchpad.net/ubuntu/+bug/1319003
> (Ubuntu 13.10)
>
> The following distros are affected:
>
> (x) Ubuntu 13.04 and derivatives (3.8)
> (v) Ubuntu 13.10 and derivatives (3.11), supported until 2014-07
> (x) Fedora 17 (3.8 and 3.9 in updates)
> (x) Fedora 18 (3.8, 3.9, 3.10, 3.11 in updates)
> (v) Fedora 19 (3.9; 3.10, 3.11, 3.12 in updates; fixed with latest update to 3.13), supported until TBA
> (v) Fedora 20 (3.11; 3.12 in updates; fixed with latest update to 3.13), supported until TBA
> (v) RHEL 7 and derivatives (3.10), expected to be supported until about 2025
> (v) openSUSE 13.1 (3.11), expected to be supported until at least 2016-08
> (v) SLES 12 (3.12), expected to be supported until about 2024
> (v) Mageia 3 (3.8), supported until 2014-11-19
> (v) Mageia 4 (3.12), supported until 2015-08-01
> (v) Oracle Enterprise Linux with Unbreakable Enterprise Kernel Release 3 (3.8), supported until TBA
>
> Here is the analysis of the problem and what was put in the RHEL7 bug.
> The Oracle bug does not exist (as I just backport them in the kernel and
> send a GIT PULL to Jerry) - but if you would like I can certainly furnish
> you with one (it would be identical to what is mentioned below).
>
> If you are OK with the backport, I am volunteering Roger and Felipe to assist
> in jamming^H^H^H^Hbackporting the patches into earlier kernels.
>
> Summary:
> Storage performance regression when Xen backend lacks persistent-grants support
>
> Description of problem:
> When used as a Xen guest, RHEL 7 will be slower than older releases in terms
> s of storage performance. This is due to the persistent-grants feature introduced
> in xen-blkfront on the Linux Kernel 3.8 series. From 3.8 to 3.12 (inclusive),
> xen-blkfront will add an extra set of memcpy() operations regardless of
> persistent-grants support in the backend (i.e. xen-blkback, qemu, tapdisk).
> This has been identified and fixed in the 3.13 kernel series, but was not
> backported to previous LTS kernels due to the nature of the bug (performance only).
>
> While persistent grants reduce the stress on the Xen grant table and allow
> for much better aggregate throughput (at the cost of an extra set of memcpy
> operations), adding the copy overhead when the feature is unsupported on
> the backend combines the worst of both worlds.   This is particularly noticeable
> when intensive storage workloads are active from many guests.
>
> How reproducible:
> This is always reproducible when a RHEL 7 guest is running on Xen and the
> storage backend (i.e. xen-blkback, qemu, tapdisk) does not have support for
> persistent grants.
>
> Steps to Reproduce:
> 1. Install a Xen dom0 running a kernel prior to 3.8 (without
> persistent-grants support) - or run it under Amazon EC2
> 2. Install a set of RHEL 7 guests (which uses kernel 3.10).
> 3. Measure aggregate storage throughput from all guests.
>
> NOTE: The storage infrastructure (e.g. local SSDs, network-attached storage)
> cannot be a bottleneck in itself. If tested on a single SATA disk, for
> example, the issue will probably be unnoticeable as the infrastructure will
> be limiting response time and throughput.
>
> Actual results:
> Aggregate storage throughput will be lower than with a xen-blkfront
> versions prior to 3.8 or newer than 3.12.
>
> Expected results:
> Aggregate storage throughput should be at least as good or better if the
> backend supports persistent grants.
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

-- 
  Vitaly
