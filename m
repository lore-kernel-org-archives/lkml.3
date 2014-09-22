Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaIVPqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:46:12 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:36515 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaIVPqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:46:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] Fix nasty 32-bit overflow bug in buffer i/o code.
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <CA+55aFwAdsJ9EWTx3QvMxs2ReTX19Xvd_s7wc+KQ8qnJjg0WDA@mail.gmail.com>
Date: Mon, 22 Sep 2014 16:46:01 +0100
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, stable <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1844C797-F3C7-4EA7-BBE8-520A7609C743@cam.ac.uk>
References: <Pine.LNX.4.64.1409220042400.2595@hermes-1.csi.cam.ac.uk> <CA+55aFyYpe=oyF9yVqF3E6t4ZCpHAdnLj1g36FWUDZydW9mdgQ@mail.gmail.com> <55E81CB2-AB4B-41E2-88D5-B33F7D8B1DB8@cam.ac.uk> <CA+55aFwAdsJ9EWTx3QvMxs2ReTX19Xvd_s7wc+KQ8qnJjg0WDA@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 22 Sep 2014, at 16:33, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Mon, Sep 22, 2014 at 8:29 AM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>> 
>> You could do "block & ~(sector_t)(size - 1)" instead of "(sector_t)index << sizebits" if you prefer but not sure that is an improvement!
> 
> No, it would be even worse. Something like
> 
>  block & ~(sector_t)((size >> 9) - 1)
> 
> because block is the sector number (ie 512-byte) and size is in bytes.

Oops, sorry.  But I think you got it wrong, too as you are ignoring the PAGE_SIZE - as was I but it is what we need to align to in addition to the problem of "size" being in bytes.  So I think the correct mask is actually based on sizebits which reflects the number of blocks per page thus:

	block & ~(sector_t)((1 << sizebits) - 1)

In any case the shift is the lesser evil I think as it is at least obviously correct whilst getting the right mask has taken us a few iterations of correcting each other! (-:

PS. Thank you for taking my patch and correcting the misleading description!

Best regards,

	Anton

>           Linus

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

