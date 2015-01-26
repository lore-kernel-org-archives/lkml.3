Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbbAZXIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:08:47 -0500
Received: from gproxy9-pub.mail.unifiedlayer.com ([69.89.20.122]:51101 "HELO
	gproxy9-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754054AbbAZXIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:08:43 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2015 18:08:43 EST
X-Authority-Analysis: v=2.1 cv=NPZGpSKg c=1 sm=1 tr=0
 a=9W6Fsu4pMcyimqnCr1W0/w==:117 a=9W6Fsu4pMcyimqnCr1W0/w==:17 a=cNaOj0WVAAAA:8
 a=f5113yIGAAAA:8 a=kj9zAlcOel0A:10 a=TBVoxVdAAAAA:8 a=GhZ5P8ky69gA:10
 a=noBwr2J6l1kA:10 a=YNv0rlydsVwA:10 a=zd2uoN0lAAAA:8 a=8dKeP_MnjSISBZ1eSeEA:9
 a=jTwm3t7mrdCKyZOE:21 a=WTck2an6gj19rEFh:21 a=CjuIK1q_8ugA:10
Date: Mon, 26 Jan 2015 15:01:55 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        <iommu@lists.linux-foundation.org>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>
Subject: Re: [PATCH 2/2] iommu/amd: use handle_mm_fault directly v2
Message-ID: <20150126150155.292bf707@jbarnes-hsw>
In-Reply-To: <54C4ECBC.5070301@amd.com>
References: <1415830228-7844-1-git-send-email-jbarnes@virtuousgeek.org>
	<1415830228-7844-2-git-send-email-jbarnes@virtuousgeek.org>
	<54C4ECBC.5070301@amd.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015 15:16:44 +0200
Oded Gabbay <oded.gabbay@amd.com> wrote:

> 
> 
> On 11/13/2014 12:10 AM, Jesse Barnes wrote:
> > This could be useful for debug in the future if we want to track
> > major/minor faults more closely, and also avoids the put_page trick we
> > used with gup.
> >
> > In order to do this, we also track the task struct in the PASID state
> > structure.  This lets us update the appropriate task stats after the
> > fault has been handled, and may aid with debug in the future as well.
> >
> > v2: drop task accounting; GPU activity may have been submitted by a
> >      different thread than the one binding the PASID (Joerg)
> >
> > Tested-by: Oded Gabbay<oded.gabbay@amd.com>
> > Signed-off-by: Jesse Barnes<jbarnes@virtuousgeek.org>
> 
> Hi Jesse,
> 
> I know I tested your patch a few months ago, but we have a new feature (still 
> internally) in the driver, which has some conflicts with this patch.
> 
> Our feature is basically doing "exception handling" by registering a callback 
> function with the iommu driver in inv_ppr_cb.
> 
> Now, with the old code (we used 3.17.2 until a few days ago), this callback 
> function was called in, at least, three use-cases (which we are testing):
> 
> (1) Writing to a "bad" system memory address, which is *not* in the process's 
> memory address space.
> 
> (2) Writing to a read-only page, which is inside the process's memory address space
> 
> (3) Reading from a page without permissions, which is inside the process's 
> memory address space
> 
> With the new code (3.19-rc5), this callback is only called in the first 
> use-case, while (2) and (3) are handled in handle_mm_fault(), which is now 
> called from do_fault. The return value of handle_mm_fault() is 0, so 
> handle_fault_error() is not called and amdkfd doesn't get notification, hence 
> our test fails.
> 
> This is a problem for us as we want to propagate these exceptions to the user 
> space HSA runtime, so it could handle them.
> 
> I have 2 questions:
> 
> 1. Why don't we call inv_ppr_cb() in any case ?

We do if we fail to allocate the vma or it's in the wrong location, but
we could extend the do_fault() handling to do it in more cases.

> 2. How come handle_mm_fault() returns 0 in cases (2) and (3) ? Or in other 
> words, what is considered to be a success in handle_mm_fault() and is it visible 
> to the user-space process ?

handle_mm_fault() is somewhat of a low level function.  We can catch
more cases in our own do_fault() code if we need to.   The x86
__do_page_fault is probably a good reference.  I mainly tried to match
existing behavior when I added the handle_mm_fault(), but may have
missed stuff.  As I said, we can extend our do_fault() to handle all
the cases we want prior to calling handle_mm_fault().

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
