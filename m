Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3JCVVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:21:15 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:60817 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab3JCVVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <20131003201204.GA28050@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
	<63caad476ca6b7f3481d5512febcb4ef3db72209.1380703263.git.agordeev@redhat.com>
	<CAPcyv4j=Huz8d+00vMJa8mCFCKWeNG9-XAc1u19v89fNruM9kg@mail.gmail.com>
	<CAPcyv4gB7R2_zn=Wvowtxcn4muWNd6aK6rsURss3rnhj0VAyfA@mail.gmail.com>
	<20131003201204.GA28050@dhcp-26-207.brq.redhat.com>
Date: Thu, 3 Oct 2013 14:21:12 -0700
Message-ID: <CAPcyv4gz2fEv=23Ju0OJiYrgYCBe+oc72GCDn37PeRdRbZ8xWA@mail.gmail.com>
Subject: Re: [PATCH RFC 34/77] ioat: Update MSI/MSI-X interrupts enablement code
From: Dan Williams <dan.j.williams@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jon Mason <jon.mason@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 1:12 PM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Wed, Oct 02, 2013 at 11:00:51AM -0700, Williams, Dan J wrote:
>> I see patch 00/77 now and I still don't see the need for ioatdma to be
>> updated.  If we fail the subsequent request_irq, the driver will still
>> fall back to trying less interrupts.
>
> In the proposed design pci_enable_msix() will never return a positive value.
> Therefore if the driver is not updated it will fallback to single MSI if
> device->common.chancnt MSI-X vectors were not allocated while it used to
> fallback to a single MSI-X in the same situation.

That's fine.  I just don't like how this patch makes the driver more
complex.  If we're making things simpler lets not expose msix internal
details and just fallback to msi directly without worrying about the
number of vectors.  I think the msix_single_vector intermediate step
should go.

...and now that I look I see a bug in ioat3_irq_reinit.

> Not to mention 'if (err > 0)'
> dead code.

Ok, then just this piece for now, but more preferable to fold it into
a msix_single_vector removal patch.

-       if (err < 0)
+       if (err)
                goto msi;
-       if (err > 0)
-               goto msix_single_vector;

--
Dan
