Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764Ab3LILTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:19:14 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:45607 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3LILTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:19:12 -0500
Message-ID: <52A5A7B5.2040904@gmail.com>
Date: Mon, 09 Dec 2013 19:21:25 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/zswap.c: add BUG() for default case in zswap_writeback_entry()
References: <52A53024.9090701@gmail.com> <52A5935A.4040709@imgtec.com> <52A5973A.7020509@gmail.com> <52A5990E.2080808@imgtec.com>
In-Reply-To: <52A5990E.2080808@imgtec.com>
Content-Type: multipart/mixed;
 boundary="------------090306010206020002090309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090306010206020002090309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/09/2013 06:18 PM, James Hogan wrote:
> On 09/12/13 10:11, Chen Gang wrote:
>>> Since the metag compiler is stuck on an old version (gcc 4.2.4), which
>>> is wrong to warn in this case, and newer versions of gcc don't appear to
>>> warn about it anyway (I just checked with gcc 4.7.2 x86_64), I have no
>>> objection to this warning remaining in the metag build.
>>>
>>
>> Do you try "EXTRA_CFLAGS=-W" with gcc 4.7.2? I guess it will report the
>> warning too, I don't feel the compiler is smart enough (except it lets
>> the long function zswap_get_swap_cache_page really inline)  :-)
> 
> EXTRA_CFLAGS=-W on gcc 4.7.2 gives me plenty of pointless unused
> parameter warnings when compiling mm/zswap.o, but not the warning you're
> trying to silence.
> 

Yeah, it will generate plenty of pointless warnings, although we still
can often find valuable bugs in these warnings.

Oh, I tried gcc 4.6.3-2 rhel version, get the same result as yours (do
not report warning), but for me, it is still a compiler's bug, it
*should* report a warning for it, we can try below:

 - modify zswap_get_swap_cache_page() to let it may return another value
   (one sample modification is in attachment)

 - compile again, it doesn't report related warning, either

 - in this case, it *should* report related warning.

Could you help to try it under gcc 4.7.2, thanks?


BTW: gcc really exists some bugs about uninitialized variable, e.g.

  one known bug: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=18501
  kernel related: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=57856


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water and life which God blessed

--------------090306010206020002090309
Content-Type: text/x-patch;
 name="diff.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff.patch"

diff --git a/mm/zswap.c b/mm/zswap.c
index 5a63f78..1853ef4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -469,8 +469,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
 		 */
 		err = radix_tree_preload(GFP_KERNEL);
 		if (err)
-			break;
-
+			return -4;
 		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */

--------------090306010206020002090309--
