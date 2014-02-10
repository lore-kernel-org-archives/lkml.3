Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaBJR44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:56:56 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:53504 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752157AbaBJR4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:56:55 -0500
Date: Mon, 10 Feb 2014 17:56:50 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: kmemleak or crc32_le  bug?
Message-ID: <20140210175650.GA25309@arm.com>
References: <52F3B2A1.4080702@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F3B2A1.4080702@itwm.fraunhofer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 05:04:49PM +0100, Bernd Schubert wrote:
> I'm frequently getting 
> 
> UG: unable to handle kernel paging request at ffff880f87550dc0
> IP: [<ffffffff813016d0>] crc32_le+0x30/0x110
> 
> called from kmemleak, see bottom of the message.
...
> With the "Cannot allocate a kmemleak_object structure" messages, 

Just curious, is the free memory low when this happens?

> somehow looks like object is not proper initialized, but update_checksum()
> checks for that. Hmm, I'm not sure about kmemcheck_shadow_lookup(), 
> especially about
> 
> > 	if (!virt_addr_valid(address))
> > 		return NULL;
> 
> So is the test 
> 
> > 	shadow = kmemcheck_shadow_lookup(addr);
> > 	if (!shadow)
> > 		return true;
> 
> right here? Shouldn't that be 'return false'?

Are you using kmemcheck and kmemleak together?

I don't think update_checksum() is called on the object being allocated
but possibly on an object being freed when kmemleak_scan() is running.
This is generally a safe operation because of the object locks in
kmemleak_scan() but when an error condition just occurred (like kmemleak
not being able to allocate memory), kmemleak gets disabled and
kmemleak_free() no longer passes the information down to update the
object's flags. At this point, the running kmemleak_scan() potentially
reads unmmapped objects.

I need to think a bit more about this. Thanks for reporting.

-- 
Catalin
