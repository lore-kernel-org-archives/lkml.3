Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaESQnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:43:46 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:42433 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbaESQnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140519155336.86E93E009B@blue.fi.intel.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz> <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org> <20140519150238.67898E009B@blue.fi.intel.com>
 <20140519151104.GA16736@infradead.org> <20140519151758.A2162E009B@blue.fi.intel.com>
 <CAMSv6X1-17HMTO=b6QOZA0Xm1combFxV4wuX1gPMUqC02EKrJA@mail.gmail.com> <20140519155336.86E93E009B@blue.fi.intel.com>
From: Armin Rigo <arigo@tunes.org>
Date: Mon, 19 May 2014 18:42:42 +0200
X-Google-Sender-Auth: Zpm89T7LbiZgAzR1OPHeTQgzDrk
Message-ID: <CAMSv6X2EmhgVou03oLTAhpGbNv712mbNWCpL2PXWCXpW9M2nCQ@mail.gmail.com>
Subject: Re: remap_file_pages() use
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On 19 May 2014 17:53, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Is it nessesary to remap in 4k chunks for you?
> What about 64k chunks? Or something bigger?

Good point.  We remap chunks of 4k, which is not much, but is already
much larger than the typical object size.  Suppose we do such a
remapping for a single object: then all other neighbouring objects
that happen to live in the same page are also copied.  Then, if some
other thread modifies these other objects, we need extra copies to
keep the objects in sync across all of their versions.

That's the reason for keeping the size of remappings as small as
possible.  But we need to measure the actual impact.  We can easily
argue that if the process is using many GB of memory, then the risk of
unrelated copies starts to decrease.  It might be fine to increase the
remapping unit in this case.

If there is an official way to know in advance how many remappings our
process is allowed to perform, then we could adapt as the size
increases.  Or maybe catching ENOMEM and doubling the remapping size
(in some process-wide synchronization point).  All in all, thanks for
the note: it looks like there are solutions (even if less elegant than
remap_file_pages from the user's perspective).


A bientôt,

Armin.
