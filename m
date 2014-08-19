Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaHSQhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:37:41 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53192 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaHSQhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:37:38 -0400
Date: Tue, 19 Aug 2014 19:37:33 +0300
From: Dan Aloni <dan@kernelim.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: Revert "aio: fix aio request leak when events are reaped by user
 space"
Message-ID: <20140819163733.GA10132@gmail.com>
References: <cover.1403632276.git.bcrl@kvack.org>
 <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Some testing I've done today indicates that the original commit broke
AIO with regard to users that overflow the maximum number of request
per IO context (where -EAGAIN is returned).

In fact, it did worse - the attached C program can easily overrun the
ring buffer that is responsible for managing the completed requests,
and caused notification about their completion never to be returned.

See attachments to this mail:

    aio_bug.c:       a program that helps to reproduce the probelm
    dmesg-bad.txt:  fs/aio.c with dynamic printk on v3.15.10.
                    The printks show how the ring buffer gets overrun.
    dmesg-good.txt: fs/aio.c with dynamic printk on a kernel with the
                    commit reverted.

For this program to work, we need enough events coming from io_submit()
in one go so that the ring buffer overflows. Local file system should
support O_DIRECT and it seems to test here correctly on a laptop with
an SSD.

I am not an expert on this code, but it looks perhaps that the reason
that put_reqs_available() was called in the original context was to
prevent this scenario exactly, and to properly manage the maximum
number of outstanding requests.

This reverts commit b34e0e1319b31202eb142dcd9688cf7145a30bf6.

Signed-off-by: Dan Aloni <dan@kernelim.com>

---
 fs/aio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 6d68e01dc7ca..45b07e8a1834 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1028,7 +1028,6 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/* everything turned out well, dispose of the aiocb. */
 	kiocb_free(iocb);
-	put_reqs_available(ctx, 1);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -1111,6 +1110,8 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	flush_dcache_page(ctx->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, tail);
+
+	put_reqs_available(ctx, ret);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
-- 
1.9.3

-- 
Dan Aloni

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-bad.txt"

[ 2966.641825] aio_setup_ring: pid(9966) page[0]->count=3
[ 2966.641829] aio_setup_ring: attempting mmap of 4096 bytes
[ 2966.641834] aio_setup_ring: mmap address: 0x7ff021605000
[ 2966.641837] ioctx_alloc: allocated ioctx ffff8800c85fc000[140669328838656]: mm=ffff8801f7f5ec00 mask=0x7f
[ 2966.642645] aio_complete: ffff8800c85fc000[1]: ffff8801f7e5a280: 0000000000603cc0 0 1000 0
[ 2966.642647] aio_complete: added to ring ffff8801f7e5a280 at [1]
[ 2966.642650] aio_complete: ffff8800c85fc000[2]: ffff8801f7e5a280: 0000000000603d00 0 1000 0
[ 2966.642651] aio_complete: added to ring ffff8801f7e5a280 at [2]
[ 2966.642654] aio_complete: ffff8800c85fc000[3]: ffff8801f7e5a280: 0000000000603d40 0 1000 0
[ 2966.642655] aio_complete: added to ring ffff8801f7e5a280 at [3]
[ 2966.642657] aio_complete: ffff8800c85fc000[4]: ffff8801f7e5a280: 0000000000603d80 0 1000 0
[ 2966.642658] aio_complete: added to ring ffff8801f7e5a280 at [4]
[ 2966.642661] aio_complete: ffff8800c85fc000[5]: ffff8801f7e5a280: 0000000000603dc0 0 1000 0
[ 2966.642662] aio_complete: added to ring ffff8801f7e5a280 at [5]
[ 2966.642664] aio_complete: ffff8800c85fc000[6]: ffff8801f7e5a280: 0000000000603e00 0 1000 0
[ 2966.642665] aio_complete: added to ring ffff8801f7e5a280 at [6]
[ 2966.642668] aio_complete: ffff8800c85fc000[7]: ffff8801f7e5a280: 0000000000603e40 0 1000 0
[ 2966.642670] aio_complete: added to ring ffff8801f7e5a280 at [7]
[ 2966.642676] aio_complete: ffff8800c85fc000[8]: ffff8801f7e5a280: 0000000000603e80 0 1000 0
[ 2966.642677] aio_complete: added to ring ffff8801f7e5a280 at [8]
[ 2966.642680] aio_complete: ffff8800c85fc000[9]: ffff8801f7e5a280: 0000000000603ec0 0 1000 0
[ 2966.642680] aio_complete: added to ring ffff8801f7e5a280 at [9]
[ 2966.642683] aio_complete: ffff8800c85fc000[10]: ffff8801f7e5a280: 0000000000603f00 0 1000 0
[ 2966.642684] aio_complete: added to ring ffff8801f7e5a280 at [10]
[ 2966.642686] aio_complete: ffff8800c85fc000[11]: ffff8801f7e5a280: 0000000000603f40 0 1000 0
[ 2966.642687] aio_complete: added to ring ffff8801f7e5a280 at [11]
[ 2966.642690] aio_complete: ffff8800c85fc000[12]: ffff8801f7e5a280: 0000000000603f80 0 1000 0
[ 2966.642691] aio_complete: added to ring ffff8801f7e5a280 at [12]
[ 2966.642693] aio_complete: ffff8800c85fc000[13]: ffff8801f7e5a280: 0000000000603fc0 0 1000 0
[ 2966.642694] aio_complete: added to ring ffff8801f7e5a280 at [13]
[ 2966.642697] aio_complete: ffff8800c85fc000[14]: ffff8801f7e5a280: 0000000000604000 0 1000 0
[ 2966.642698] aio_complete: added to ring ffff8801f7e5a280 at [14]
[ 2966.642700] aio_complete: ffff8800c85fc000[15]: ffff8801f7e5a280: 0000000000604040 0 1000 0
[ 2966.642701] aio_complete: added to ring ffff8801f7e5a280 at [15]
[ 2966.642704] aio_complete: ffff8800c85fc000[16]: ffff8801f7e5a280: 0000000000604080 0 1000 0
[ 2966.642704] aio_complete: added to ring ffff8801f7e5a280 at [16]
[ 2966.642707] aio_complete: ffff8800c85fc000[17]: ffff8801f7e5a280: 00000000006040c0 0 1000 0
[ 2966.642708] aio_complete: added to ring ffff8801f7e5a280 at [17]
[ 2966.642710] aio_complete: ffff8800c85fc000[18]: ffff8801f7e5a280: 0000000000604100 0 1000 0
[ 2966.642711] aio_complete: added to ring ffff8801f7e5a280 at [18]
[ 2966.642714] aio_complete: ffff8800c85fc000[19]: ffff8801f7e5a280: 0000000000604140 0 1000 0
[ 2966.642715] aio_complete: added to ring ffff8801f7e5a280 at [19]
[ 2966.642717] aio_complete: ffff8800c85fc000[20]: ffff8801f7e5a280: 0000000000604180 0 1000 0
[ 2966.642718] aio_complete: added to ring ffff8801f7e5a280 at [20]
[ 2966.642720] aio_complete: ffff8800c85fc000[21]: ffff8801f7e5a280: 00000000006041c0 0 1000 0
[ 2966.642721] aio_complete: added to ring ffff8801f7e5a280 at [21]
[ 2966.642725] aio_complete: ffff8800c85fc000[22]: ffff8801f7e5a280: 0000000000604200 0 1000 0
[ 2966.642725] aio_complete: added to ring ffff8801f7e5a280 at [22]
[ 2966.642728] aio_complete: ffff8800c85fc000[23]: ffff8801f7e5a280: 0000000000604240 0 1000 0
[ 2966.642729] aio_complete: added to ring ffff8801f7e5a280 at [23]
[ 2966.642731] aio_complete: ffff8800c85fc000[24]: ffff8801f7e5a280: 0000000000604280 0 1000 0
[ 2966.642732] aio_complete: added to ring ffff8801f7e5a280 at [24]
[ 2966.642735] aio_complete: ffff8800c85fc000[25]: ffff8801f7e5a280: 00000000006042c0 0 1000 0
[ 2966.642735] aio_complete: added to ring ffff8801f7e5a280 at [25]
[ 2966.642738] aio_complete: ffff8800c85fc000[26]: ffff8801f7e5a280: 0000000000604300 0 1000 0
[ 2966.642739] aio_complete: added to ring ffff8801f7e5a280 at [26]
[ 2966.642741] aio_complete: ffff8800c85fc000[27]: ffff8801f7e5a280: 0000000000604340 0 1000 0
[ 2966.642742] aio_complete: added to ring ffff8801f7e5a280 at [27]
[ 2966.642745] aio_complete: ffff8800c85fc000[28]: ffff8801f7e5a280: 0000000000604380 0 1000 0
[ 2966.642745] aio_complete: added to ring ffff8801f7e5a280 at [28]
[ 2966.642748] aio_complete: ffff8800c85fc000[29]: ffff8801f7e5a280: 00000000006043c0 0 1000 0
[ 2966.642749] aio_complete: added to ring ffff8801f7e5a280 at [29]
[ 2966.642751] aio_complete: ffff8800c85fc000[30]: ffff8801f7e5a280: 0000000000604400 0 1000 0
[ 2966.642752] aio_complete: added to ring ffff8801f7e5a280 at [30]
[ 2966.642755] aio_complete: ffff8800c85fc000[31]: ffff8801f7e5a280: 0000000000604440 0 1000 0
[ 2966.642756] aio_complete: added to ring ffff8801f7e5a280 at [31]
[ 2966.642758] aio_complete: ffff8800c85fc000[32]: ffff8801f7e5a280: 0000000000604480 0 1000 0
[ 2966.642759] aio_complete: added to ring ffff8801f7e5a280 at [32]
[ 2966.642761] aio_complete: ffff8800c85fc000[33]: ffff8801f7e5a280: 00000000006044c0 0 1000 0
[ 2966.642762] aio_complete: added to ring ffff8801f7e5a280 at [33]
[ 2966.642765] aio_complete: ffff8800c85fc000[34]: ffff8801f7e5a280: 0000000000604500 0 1000 0
[ 2966.642766] aio_complete: added to ring ffff8801f7e5a280 at [34]
[ 2966.642768] aio_complete: ffff8800c85fc000[35]: ffff8801f7e5a280: 0000000000604540 0 1000 0
[ 2966.642769] aio_complete: added to ring ffff8801f7e5a280 at [35]
[ 2966.642772] aio_complete: ffff8800c85fc000[36]: ffff8801f7e5a280: 0000000000604580 0 1000 0
[ 2966.642773] aio_complete: added to ring ffff8801f7e5a280 at [36]
[ 2966.642775] aio_complete: ffff8800c85fc000[37]: ffff8801f7e5a280: 00000000006045c0 0 1000 0
[ 2966.642776] aio_complete: added to ring ffff8801f7e5a280 at [37]
[ 2966.642779] aio_complete: ffff8800c85fc000[38]: ffff8801f7e5a280: 0000000000604600 0 1000 0
[ 2966.642780] aio_complete: added to ring ffff8801f7e5a280 at [38]
[ 2966.642784] aio_complete: ffff8800c85fc000[39]: ffff8801f7e5a280: 0000000000604640 0 1000 0
[ 2966.642785] aio_complete: added to ring ffff8801f7e5a280 at [39]
[ 2966.642787] aio_complete: ffff8800c85fc000[40]: ffff8801f7e5a280: 0000000000604680 0 1000 0
[ 2966.642788] aio_complete: added to ring ffff8801f7e5a280 at [40]
[ 2966.642791] aio_complete: ffff8800c85fc000[41]: ffff8801f7e5a280: 00000000006046c0 0 1000 0
[ 2966.642792] aio_complete: added to ring ffff8801f7e5a280 at [41]
[ 2966.642794] aio_complete: ffff8800c85fc000[42]: ffff8801f7e5a280: 0000000000604700 0 1000 0
[ 2966.642795] aio_complete: added to ring ffff8801f7e5a280 at [42]
[ 2966.642797] aio_complete: ffff8800c85fc000[43]: ffff8801f7e5a280: 0000000000604740 0 1000 0
[ 2966.642798] aio_complete: added to ring ffff8801f7e5a280 at [43]
[ 2966.642801] aio_complete: ffff8800c85fc000[44]: ffff8801f7e5a280: 0000000000604780 0 1000 0
[ 2966.642802] aio_complete: added to ring ffff8801f7e5a280 at [44]
[ 2966.642804] aio_complete: ffff8800c85fc000[45]: ffff8801f7e5a280: 00000000006047c0 0 1000 0
[ 2966.642805] aio_complete: added to ring ffff8801f7e5a280 at [45]
[ 2966.642807] aio_complete: ffff8800c85fc000[46]: ffff8801f7e5a280: 0000000000604800 0 1000 0
[ 2966.642808] aio_complete: added to ring ffff8801f7e5a280 at [46]
[ 2966.642811] aio_complete: ffff8800c85fc000[47]: ffff8801f7e5a280: 0000000000604840 0 1000 0
[ 2966.642812] aio_complete: added to ring ffff8801f7e5a280 at [47]
[ 2966.642814] aio_complete: ffff8800c85fc000[48]: ffff8801f7e5a280: 0000000000604880 0 1000 0
[ 2966.642815] aio_complete: added to ring ffff8801f7e5a280 at [48]
[ 2966.642818] aio_complete: ffff8800c85fc000[49]: ffff8801f7e5a280: 00000000006048c0 0 1000 0
[ 2966.642819] aio_complete: added to ring ffff8801f7e5a280 at [49]
[ 2966.642822] aio_complete: ffff8800c85fc000[50]: ffff8801f7e5a280: 0000000000604900 0 1000 0
[ 2966.642823] aio_complete: added to ring ffff8801f7e5a280 at [50]
[ 2966.642825] aio_complete: ffff8800c85fc000[51]: ffff8801f7e5a280: 0000000000604940 0 1000 0
[ 2966.642826] aio_complete: added to ring ffff8801f7e5a280 at [51]
[ 2966.642828] aio_complete: ffff8800c85fc000[52]: ffff8801f7e5a280: 0000000000604980 0 1000 0
[ 2966.642829] aio_complete: added to ring ffff8801f7e5a280 at [52]
[ 2966.642832] aio_complete: ffff8800c85fc000[53]: ffff8801f7e5a280: 00000000006049c0 0 1000 0
[ 2966.642833] aio_complete: added to ring ffff8801f7e5a280 at [53]
[ 2966.642835] aio_complete: ffff8800c85fc000[54]: ffff8801f7e5a280: 0000000000604a00 0 1000 0
[ 2966.642836] aio_complete: added to ring ffff8801f7e5a280 at [54]
[ 2966.642838] aio_complete: ffff8800c85fc000[55]: ffff8801f7e5a280: 0000000000604a40 0 1000 0
[ 2966.642839] aio_complete: added to ring ffff8801f7e5a280 at [55]
[ 2966.642842] aio_complete: ffff8800c85fc000[56]: ffff8801f7e5a280: 0000000000604a80 0 1000 0
[ 2966.642843] aio_complete: added to ring ffff8801f7e5a280 at [56]
[ 2966.642845] aio_complete: ffff8800c85fc000[57]: ffff8801f7e5a280: 0000000000604ac0 0 1000 0
[ 2966.642846] aio_complete: added to ring ffff8801f7e5a280 at [57]
[ 2966.642849] aio_complete: ffff8800c85fc000[58]: ffff8801f7e5a280: 0000000000604b00 0 1000 0
[ 2966.642849] aio_complete: added to ring ffff8801f7e5a280 at [58]
[ 2966.642852] aio_complete: ffff8800c85fc000[59]: ffff8801f7e5a280: 0000000000604b40 0 1000 0
[ 2966.642853] aio_complete: added to ring ffff8801f7e5a280 at [59]
[ 2966.642855] aio_complete: ffff8800c85fc000[60]: ffff8801f7e5a280: 0000000000604b80 0 1000 0
[ 2966.642856] aio_complete: added to ring ffff8801f7e5a280 at [60]
[ 2966.642859] aio_complete: ffff8800c85fc000[61]: ffff8801f7e5a280: 0000000000604bc0 0 1000 0
[ 2966.642860] aio_complete: added to ring ffff8801f7e5a280 at [61]
[ 2966.642862] aio_complete: ffff8800c85fc000[62]: ffff8801f7e5a280: 0000000000604c00 0 1000 0
[ 2966.642863] aio_complete: added to ring ffff8801f7e5a280 at [62]
[ 2966.642865] aio_complete: ffff8800c85fc000[63]: ffff8801f7e5a280: 0000000000604c40 0 1000 0
[ 2966.642866] aio_complete: added to ring ffff8801f7e5a280 at [63]
[ 2966.642869] aio_complete: ffff8800c85fc000[64]: ffff8801f7e5a280: 0000000000604c80 0 1000 0
[ 2966.642870] aio_complete: added to ring ffff8801f7e5a280 at [64]
[ 2966.642873] aio_complete: ffff8800c85fc000[65]: ffff8801f7e5a280: 0000000000604cc0 0 1000 0
[ 2966.642874] aio_complete: added to ring ffff8801f7e5a280 at [65]
[ 2966.642876] aio_complete: ffff8800c85fc000[66]: ffff8801f7e5a280: 0000000000604d00 0 1000 0
[ 2966.642877] aio_complete: added to ring ffff8801f7e5a280 at [66]
[ 2966.642879] aio_complete: ffff8800c85fc000[67]: ffff8801f7e5a280: 0000000000604d40 0 1000 0
[ 2966.642880] aio_complete: added to ring ffff8801f7e5a280 at [67]
[ 2966.642883] aio_complete: ffff8800c85fc000[68]: ffff8801f7e5a280: 0000000000604d80 0 1000 0
[ 2966.642884] aio_complete: added to ring ffff8801f7e5a280 at [68]
[ 2966.642886] aio_complete: ffff8800c85fc000[69]: ffff8801f7e5a280: 0000000000604dc0 0 1000 0
[ 2966.642887] aio_complete: added to ring ffff8801f7e5a280 at [69]
[ 2966.642891] aio_complete: ffff8800c85fc000[70]: ffff8801f7e5a280: 0000000000604e00 0 1000 0
[ 2966.642892] aio_complete: added to ring ffff8801f7e5a280 at [70]
[ 2966.642894] aio_complete: ffff8800c85fc000[71]: ffff8801f7e5a280: 0000000000604e40 0 1000 0
[ 2966.642895] aio_complete: added to ring ffff8801f7e5a280 at [71]
[ 2966.642898] aio_complete: ffff8800c85fc000[72]: ffff8801f7e5a280: 0000000000604e80 0 1000 0
[ 2966.642899] aio_complete: added to ring ffff8801f7e5a280 at [72]
[ 2966.642901] aio_complete: ffff8800c85fc000[73]: ffff8801f7e5a280: 0000000000604ec0 0 1000 0
[ 2966.642902] aio_complete: added to ring ffff8801f7e5a280 at [73]
[ 2966.642904] aio_complete: ffff8800c85fc000[74]: ffff8801f7e5a280: 0000000000604f00 0 1000 0
[ 2966.642905] aio_complete: added to ring ffff8801f7e5a280 at [74]
[ 2966.642908] aio_complete: ffff8800c85fc000[75]: ffff8801f7e5a280: 0000000000604f40 0 1000 0
[ 2966.642909] aio_complete: added to ring ffff8801f7e5a280 at [75]
[ 2966.642911] aio_complete: ffff8800c85fc000[76]: ffff8801f7e5a280: 0000000000604f80 0 1000 0
[ 2966.642912] aio_complete: added to ring ffff8801f7e5a280 at [76]
[ 2966.642914] aio_complete: ffff8800c85fc000[77]: ffff8801f7e5a280: 0000000000604fc0 0 1000 0
[ 2966.642915] aio_complete: added to ring ffff8801f7e5a280 at [77]
[ 2966.642918] aio_complete: ffff8800c85fc000[78]: ffff8801f7e5a280: 0000000000605000 0 1000 0
[ 2966.642919] aio_complete: added to ring ffff8801f7e5a280 at [78]
[ 2966.642922] aio_complete: ffff8800c85fc000[79]: ffff8801f7e5a280: 0000000000605040 0 1000 0
[ 2966.642923] aio_complete: added to ring ffff8801f7e5a280 at [79]
[ 2966.642925] aio_complete: ffff8800c85fc000[80]: ffff8801f7e5a280: 0000000000605080 0 1000 0
[ 2966.642926] aio_complete: added to ring ffff8801f7e5a280 at [80]
[ 2966.642929] aio_complete: ffff8800c85fc000[81]: ffff8801f7e5a280: 00000000006050c0 0 1000 0
[ 2966.642929] aio_complete: added to ring ffff8801f7e5a280 at [81]
[ 2966.642932] aio_complete: ffff8800c85fc000[82]: ffff8801f7e5a280: 0000000000605100 0 1000 0
[ 2966.642933] aio_complete: added to ring ffff8801f7e5a280 at [82]
[ 2966.642935] aio_complete: ffff8800c85fc000[83]: ffff8801f7e5a280: 0000000000605140 0 1000 0
[ 2966.642936] aio_complete: added to ring ffff8801f7e5a280 at [83]
[ 2966.642939] aio_complete: ffff8800c85fc000[84]: ffff8801f7e5a280: 0000000000605180 0 1000 0
[ 2966.642939] aio_complete: added to ring ffff8801f7e5a280 at [84]
[ 2966.642942] aio_complete: ffff8800c85fc000[85]: ffff8801f7e5a280: 00000000006051c0 0 1000 0
[ 2966.642943] aio_complete: added to ring ffff8801f7e5a280 at [85]
[ 2966.642945] aio_complete: ffff8800c85fc000[86]: ffff8801f7e5a280: 0000000000605200 0 1000 0
[ 2966.642946] aio_complete: added to ring ffff8801f7e5a280 at [86]
[ 2966.642949] aio_complete: ffff8800c85fc000[87]: ffff8801f7e5a280: 0000000000605240 0 1000 0
[ 2966.642950] aio_complete: added to ring ffff8801f7e5a280 at [87]
[ 2966.642952] aio_complete: ffff8800c85fc000[88]: ffff8801f7e5a280: 0000000000605280 0 1000 0
[ 2966.642953] aio_complete: added to ring ffff8801f7e5a280 at [88]
[ 2966.642955] aio_complete: ffff8800c85fc000[89]: ffff8801f7e5a280: 00000000006052c0 0 1000 0
[ 2966.642956] aio_complete: added to ring ffff8801f7e5a280 at [89]
[ 2966.642959] aio_complete: ffff8800c85fc000[90]: ffff8801f7e5a280: 0000000000605300 0 1000 0
[ 2966.642960] aio_complete: added to ring ffff8801f7e5a280 at [90]
[ 2966.642962] aio_complete: ffff8800c85fc000[91]: ffff8801f7e5a280: 0000000000605340 0 1000 0
[ 2966.642963] aio_complete: added to ring ffff8801f7e5a280 at [91]
[ 2966.642966] aio_complete: ffff8800c85fc000[92]: ffff8801f7e5a280: 0000000000605380 0 1000 0
[ 2966.642967] aio_complete: added to ring ffff8801f7e5a280 at [92]
[ 2966.642969] aio_complete: ffff8800c85fc000[93]: ffff8801f7e5a280: 00000000006053c0 0 1000 0
[ 2966.642970] aio_complete: added to ring ffff8801f7e5a280 at [93]
[ 2966.642973] aio_complete: ffff8800c85fc000[94]: ffff8801f7e5a280: 0000000000605400 0 1000 0
[ 2966.642974] aio_complete: added to ring ffff8801f7e5a280 at [94]
[ 2966.642976] aio_complete: ffff8800c85fc000[95]: ffff8801f7e5a280: 0000000000605440 0 1000 0
[ 2966.642977] aio_complete: added to ring ffff8801f7e5a280 at [95]
[ 2966.642979] aio_complete: ffff8800c85fc000[96]: ffff8801f7e5a280: 0000000000605480 0 1000 0
[ 2966.642980] aio_complete: added to ring ffff8801f7e5a280 at [96]
[ 2966.642983] aio_complete: ffff8800c85fc000[97]: ffff8801f7e5a280: 00000000006054c0 0 1000 0
[ 2966.642984] aio_complete: added to ring ffff8801f7e5a280 at [97]
[ 2966.642986] aio_complete: ffff8800c85fc000[98]: ffff8801f7e5a280: 0000000000605500 0 1000 0
[ 2966.642987] aio_complete: added to ring ffff8801f7e5a280 at [98]
[ 2966.642989] aio_complete: ffff8800c85fc000[99]: ffff8801f7e5a280: 0000000000605540 0 1000 0
[ 2966.642990] aio_complete: added to ring ffff8801f7e5a280 at [99]
[ 2966.642993] aio_complete: ffff8800c85fc000[100]: ffff8801f7e5a280: 0000000000605580 0 1000 0
[ 2966.642994] aio_complete: added to ring ffff8801f7e5a280 at [100]
[ 2966.642998] aio_complete: ffff8800c85fc000[101]: ffff8801f7e5a280: 00000000006055c0 0 1000 0
[ 2966.642998] aio_complete: added to ring ffff8801f7e5a280 at [101]
[ 2966.643001] aio_complete: ffff8800c85fc000[102]: ffff8801f7e5a280: 0000000000605600 0 1000 0
[ 2966.643002] aio_complete: added to ring ffff8801f7e5a280 at [102]
[ 2966.643004] aio_complete: ffff8800c85fc000[103]: ffff8801f7e5a280: 0000000000605640 0 1000 0
[ 2966.643005] aio_complete: added to ring ffff8801f7e5a280 at [103]
[ 2966.643008] aio_complete: ffff8800c85fc000[104]: ffff8801f7e5a280: 0000000000605680 0 1000 0
[ 2966.643009] aio_complete: added to ring ffff8801f7e5a280 at [104]
[ 2966.643011] aio_complete: ffff8800c85fc000[105]: ffff8801f7e5a280: 00000000006056c0 0 1000 0
[ 2966.643012] aio_complete: added to ring ffff8801f7e5a280 at [105]
[ 2966.643015] aio_complete: ffff8800c85fc000[106]: ffff8801f7e5a280: 0000000000605700 0 1000 0
[ 2966.643016] aio_complete: added to ring ffff8801f7e5a280 at [106]
[ 2966.643018] aio_complete: ffff8800c85fc000[107]: ffff8801f7e5a280: 0000000000605740 0 1000 0
[ 2966.643019] aio_complete: added to ring ffff8801f7e5a280 at [107]
[ 2966.643022] aio_complete: ffff8800c85fc000[108]: ffff8801f7e5a280: 0000000000605780 0 1000 0
[ 2966.643023] aio_complete: added to ring ffff8801f7e5a280 at [108]
[ 2966.643025] aio_complete: ffff8800c85fc000[109]: ffff8801f7e5a280: 00000000006057c0 0 1000 0
[ 2966.643026] aio_complete: added to ring ffff8801f7e5a280 at [109]
[ 2966.643028] aio_complete: ffff8800c85fc000[110]: ffff8801f7e5a280: 0000000000605800 0 1000 0
[ 2966.643029] aio_complete: added to ring ffff8801f7e5a280 at [110]
[ 2966.643032] aio_complete: ffff8800c85fc000[111]: ffff8801f7e5a280: 0000000000605840 0 1000 0
[ 2966.643033] aio_complete: added to ring ffff8801f7e5a280 at [111]
[ 2966.643035] aio_complete: ffff8800c85fc000[112]: ffff8801f7e5a280: 0000000000605880 0 1000 0
[ 2966.643036] aio_complete: added to ring ffff8801f7e5a280 at [112]
[ 2966.643038] aio_complete: ffff8800c85fc000[113]: ffff8801f7e5a280: 00000000006058c0 0 1000 0
[ 2966.643039] aio_complete: added to ring ffff8801f7e5a280 at [113]
[ 2966.643042] aio_complete: ffff8800c85fc000[114]: ffff8801f7e5a280: 0000000000605900 0 1000 0
[ 2966.643043] aio_complete: added to ring ffff8801f7e5a280 at [114]
[ 2966.643045] aio_complete: ffff8800c85fc000[115]: ffff8801f7e5a280: 0000000000605940 0 1000 0
[ 2966.643046] aio_complete: added to ring ffff8801f7e5a280 at [115]
[ 2966.643049] aio_complete: ffff8800c85fc000[116]: ffff8801f7e5a280: 0000000000605980 0 1000 0
[ 2966.643049] aio_complete: added to ring ffff8801f7e5a280 at [116]
[ 2966.643052] aio_complete: ffff8800c85fc000[117]: ffff8801f7e5a280: 00000000006059c0 0 1000 0
[ 2966.643053] aio_complete: added to ring ffff8801f7e5a280 at [117]
[ 2966.643055] aio_complete: ffff8800c85fc000[118]: ffff8801f7e5a280: 0000000000605a00 0 1000 0
[ 2966.643056] aio_complete: added to ring ffff8801f7e5a280 at [118]
[ 2966.643059] aio_complete: ffff8800c85fc000[119]: ffff8801f7e5a280: 0000000000605a40 0 1000 0
[ 2966.643060] aio_complete: added to ring ffff8801f7e5a280 at [119]
[ 2966.643063] aio_complete: ffff8800c85fc000[120]: ffff8801f7e5a280: 0000000000605a80 0 1000 0
[ 2966.643064] aio_complete: added to ring ffff8801f7e5a280 at [120]
[ 2966.643066] aio_complete: ffff8800c85fc000[121]: ffff8801f7e5a280: 0000000000605ac0 0 1000 0
[ 2966.643067] aio_complete: added to ring ffff8801f7e5a280 at [121]
[ 2966.643069] aio_complete: ffff8800c85fc000[122]: ffff8801f7e5a280: 0000000000605b00 0 1000 0
[ 2966.643070] aio_complete: added to ring ffff8801f7e5a280 at [122]
[ 2966.643073] aio_complete: ffff8800c85fc000[123]: ffff8801f7e5a280: 0000000000605b40 0 1000 0
[ 2966.643074] aio_complete: added to ring ffff8801f7e5a280 at [123]
[ 2966.643076] aio_complete: ffff8800c85fc000[124]: ffff8801f7e5a280: 0000000000605b80 0 1000 0
[ 2966.643077] aio_complete: added to ring ffff8801f7e5a280 at [124]
[ 2966.643079] aio_complete: ffff8800c85fc000[125]: ffff8801f7e5a280: 0000000000605bc0 0 1000 0
[ 2966.643080] aio_complete: added to ring ffff8801f7e5a280 at [125]
[ 2966.643083] aio_complete: ffff8800c85fc000[126]: ffff8801f7e5a280: 0000000000605c00 0 1000 0
[ 2966.643084] aio_complete: added to ring ffff8801f7e5a280 at [126]
[ 2966.643086] aio_complete: ffff8800c85fc000[0]: ffff8801f7e5a280: 0000000000605c40 0 1000 0
[ 2966.643087] aio_complete: added to ring ffff8801f7e5a280 at [0]
[ 2966.643089] aio_complete: ffff8800c85fc000[1]: ffff8801f7e5a280: 0000000000605c80 0 1000 0
[ 2966.643090] aio_complete: added to ring ffff8801f7e5a280 at [1]
[ 2966.643147] aio_read_events_ring: h0 t1 m127
[ 2966.643149] aio_read_events_ring: 1  h1 t1
[ 2966.643150] aio_read_events_ring: h1 t1 m127
[ 2966.699376] aio_read_events_ring: h0 t0 m511
[ 2966.699386] aio_read_events_ring: h0 t0 m511
[ 2966.699389] aio_read_events_ring: h0 t0 m511
[ 2966.799574] aio_read_events_ring: h0 t0 m511

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-good.txt"

[ 3048.065378] aio_setup_ring: pid(1025) page[0]->count=3
[ 3048.065380] aio_setup_ring: attempting mmap of 4096 bytes
[ 3048.065382] aio_setup_ring: mmap address: 0x7f6cae9aa000
[ 3048.065383] ioctx_alloc: allocated ioctx ffff8800b6e4b200[140104762564608]: mm=ffff8800b6da9000 mask=0x7f
[ 3048.065556] aio_complete: ffff8800b6e4b200[1]: ffff8800b6786e00: 0000000000603cc0 0 1000 0
[ 3048.065558] aio_complete: added to ring ffff8800b6786e00 at [1]
[ 3048.065561] aio_complete: ffff8800b6e4b200[2]: ffff8800b6786e00: 0000000000603d00 0 1000 0
[ 3048.065562] aio_complete: added to ring ffff8800b6786e00 at [2]
[ 3048.065565] aio_complete: ffff8800b6e4b200[3]: ffff8800b6786e00: 0000000000603d40 0 1000 0
[ 3048.065566] aio_complete: added to ring ffff8800b6786e00 at [3]
[ 3048.065569] aio_complete: ffff8800b6e4b200[4]: ffff8800b6786e00: 0000000000603d80 0 1000 0
[ 3048.065570] aio_complete: added to ring ffff8800b6786e00 at [4]
[ 3048.065573] aio_complete: ffff8800b6e4b200[5]: ffff8800b6786e00: 0000000000603dc0 0 1000 0
[ 3048.065574] aio_complete: added to ring ffff8800b6786e00 at [5]
[ 3048.065591] aio_complete: ffff8800b6e4b200[6]: ffff8800b6786e00: 0000000000603e00 0 1000 0
[ 3048.065595] aio_complete: added to ring ffff8800b6786e00 at [6]
[ 3048.065602] aio_complete: ffff8800b6e4b200[7]: ffff8800b6786e00: 0000000000603e40 0 1000 0
[ 3048.065603] aio_complete: added to ring ffff8800b6786e00 at [7]
[ 3048.065607] aio_complete: ffff8800b6e4b200[8]: ffff8800b6786e00: 0000000000603e80 0 1000 0
[ 3048.065608] aio_complete: added to ring ffff8800b6786e00 at [8]
[ 3048.065611] aio_complete: ffff8800b6e4b200[9]: ffff8800b6786e00: 0000000000603ec0 0 1000 0
[ 3048.065612] aio_complete: added to ring ffff8800b6786e00 at [9]
[ 3048.065615] aio_complete: ffff8800b6e4b200[10]: ffff8800b6786e00: 0000000000603f00 0 1000 0
[ 3048.065616] aio_complete: added to ring ffff8800b6786e00 at [10]
[ 3048.065619] aio_complete: ffff8800b6e4b200[11]: ffff8800b6786e00: 0000000000603f40 0 1000 0
[ 3048.065620] aio_complete: added to ring ffff8800b6786e00 at [11]
[ 3048.065623] aio_complete: ffff8800b6e4b200[12]: ffff8800b6786e00: 0000000000603f80 0 1000 0
[ 3048.065623] aio_complete: added to ring ffff8800b6786e00 at [12]
[ 3048.065626] aio_complete: ffff8800b6e4b200[13]: ffff8800b6786e00: 0000000000603fc0 0 1000 0
[ 3048.065627] aio_complete: added to ring ffff8800b6786e00 at [13]
[ 3048.065631] aio_complete: ffff8800b6e4b200[14]: ffff8800b6786e00: 0000000000604000 0 1000 0
[ 3048.065632] aio_complete: added to ring ffff8800b6786e00 at [14]
[ 3048.065635] aio_complete: ffff8800b6e4b200[15]: ffff8800b6786e00: 0000000000604040 0 1000 0
[ 3048.065635] aio_complete: added to ring ffff8800b6786e00 at [15]
[ 3048.065638] aio_complete: ffff8800b6e4b200[16]: ffff8800b6786e00: 0000000000604080 0 1000 0
[ 3048.065639] aio_complete: added to ring ffff8800b6786e00 at [16]
[ 3048.065642] aio_complete: ffff8800b6e4b200[17]: ffff8800b6786e00: 00000000006040c0 0 1000 0
[ 3048.065643] aio_complete: added to ring ffff8800b6786e00 at [17]
[ 3048.065646] aio_complete: ffff8800b6e4b200[18]: ffff8800b6786e00: 0000000000604100 0 1000 0
[ 3048.065647] aio_complete: added to ring ffff8800b6786e00 at [18]
[ 3048.065650] aio_complete: ffff8800b6e4b200[19]: ffff8800b6786e00: 0000000000604140 0 1000 0
[ 3048.065651] aio_complete: added to ring ffff8800b6786e00 at [19]
[ 3048.065654] aio_complete: ffff8800b6e4b200[20]: ffff8800b6786e00: 0000000000604180 0 1000 0
[ 3048.065655] aio_complete: added to ring ffff8800b6786e00 at [20]
[ 3048.065658] aio_complete: ffff8800b6e4b200[21]: ffff8800b6786e00: 00000000006041c0 0 1000 0
[ 3048.065659] aio_complete: added to ring ffff8800b6786e00 at [21]
[ 3048.065663] aio_complete: ffff8800b6e4b200[22]: ffff8800b6786e00: 0000000000604200 0 1000 0
[ 3048.065664] aio_complete: added to ring ffff8800b6786e00 at [22]
[ 3048.065668] aio_complete: ffff8800b6e4b200[23]: ffff8800b6786e00: 0000000000604240 0 1000 0
[ 3048.065669] aio_complete: added to ring ffff8800b6786e00 at [23]
[ 3048.065672] aio_complete: ffff8800b6e4b200[24]: ffff8800b6786e00: 0000000000604280 0 1000 0
[ 3048.065672] aio_complete: added to ring ffff8800b6786e00 at [24]
[ 3048.065676] aio_complete: ffff8800b6e4b200[25]: ffff8800b6786e00: 00000000006042c0 0 1000 0
[ 3048.065677] aio_complete: added to ring ffff8800b6786e00 at [25]
[ 3048.065680] aio_complete: ffff8800b6e4b200[26]: ffff8800b6786e00: 0000000000604300 0 1000 0
[ 3048.065681] aio_complete: added to ring ffff8800b6786e00 at [26]
[ 3048.065690] aio_complete: ffff8800b6e4b200[27]: ffff8800b6786e00: 0000000000604340 0 1000 0
[ 3048.065691] aio_complete: added to ring ffff8800b6786e00 at [27]
[ 3048.065694] aio_complete: ffff8800b6e4b200[28]: ffff8800b6786e00: 0000000000604380 0 1000 0
[ 3048.065694] aio_complete: added to ring ffff8800b6786e00 at [28]
[ 3048.065697] aio_complete: ffff8800b6e4b200[29]: ffff8800b6786e00: 00000000006043c0 0 1000 0
[ 3048.065715] aio_complete: added to ring ffff8800b6786e00 at [29]
[ 3048.065721] aio_complete: ffff8800b6e4b200[30]: ffff8800b6786e00: 0000000000604400 0 1000 0
[ 3048.065722] aio_complete: added to ring ffff8800b6786e00 at [30]
[ 3048.065736] aio_complete: ffff8800b6e4b200[31]: ffff8800b6786e00: 0000000000604440 0 1000 0
[ 3048.065738] aio_complete: added to ring ffff8800b6786e00 at [31]
[ 3048.065744] aio_complete: ffff8800b6e4b200[32]: ffff8800b6786e00: 0000000000604480 0 1000 0
[ 3048.065745] aio_complete: added to ring ffff8800b6786e00 at [32]
[ 3048.065748] aio_complete: ffff8800b6e4b200[33]: ffff8800b6786e00: 00000000006044c0 0 1000 0
[ 3048.065749] aio_complete: added to ring ffff8800b6786e00 at [33]
[ 3048.065761] aio_complete: ffff8800b6e4b200[34]: ffff8800b6786e00: 0000000000604500 0 1000 0
[ 3048.065762] aio_complete: added to ring ffff8800b6786e00 at [34]
[ 3048.065765] aio_complete: ffff8800b6e4b200[35]: ffff8800b6786e00: 0000000000604540 0 1000 0
[ 3048.065765] aio_complete: added to ring ffff8800b6786e00 at [35]
[ 3048.065770] aio_complete: ffff8800b6e4b200[36]: ffff8800b6786e00: 0000000000604580 0 1000 0
[ 3048.065771] aio_complete: added to ring ffff8800b6786e00 at [36]
[ 3048.065773] aio_complete: ffff8800b6e4b200[37]: ffff8800b6786e00: 00000000006045c0 0 1000 0
[ 3048.065774] aio_complete: added to ring ffff8800b6786e00 at [37]
[ 3048.065777] aio_complete: ffff8800b6e4b200[38]: ffff8800b6786e00: 0000000000604600 0 1000 0
[ 3048.065778] aio_complete: added to ring ffff8800b6786e00 at [38]
[ 3048.065781] aio_complete: ffff8800b6e4b200[39]: ffff8800b6786e00: 0000000000604640 0 1000 0
[ 3048.065782] aio_complete: added to ring ffff8800b6786e00 at [39]
[ 3048.065785] aio_complete: ffff8800b6e4b200[40]: ffff8800b6786e00: 0000000000604680 0 1000 0
[ 3048.065786] aio_complete: added to ring ffff8800b6786e00 at [40]
[ 3048.065789] aio_complete: ffff8800b6e4b200[41]: ffff8800b6786e00: 00000000006046c0 0 1000 0
[ 3048.065790] aio_complete: added to ring ffff8800b6786e00 at [41]
[ 3048.065793] aio_complete: ffff8800b6e4b200[42]: ffff8800b6786e00: 0000000000604700 0 1000 0
[ 3048.065794] aio_complete: added to ring ffff8800b6786e00 at [42]
[ 3048.065797] aio_complete: ffff8800b6e4b200[43]: ffff8800b6786e00: 0000000000604740 0 1000 0
[ 3048.065798] aio_complete: added to ring ffff8800b6786e00 at [43]
[ 3048.065801] aio_complete: ffff8800b6e4b200[44]: ffff8800b6786e00: 0000000000604780 0 1000 0
[ 3048.065802] aio_complete: added to ring ffff8800b6786e00 at [44]
[ 3048.065805] aio_complete: ffff8800b6e4b200[45]: ffff8800b6786e00: 00000000006047c0 0 1000 0
[ 3048.065806] aio_complete: added to ring ffff8800b6786e00 at [45]
[ 3048.065809] aio_complete: ffff8800b6e4b200[46]: ffff8800b6786e00: 0000000000604800 0 1000 0
[ 3048.065809] aio_complete: added to ring ffff8800b6786e00 at [46]
[ 3048.065812] aio_complete: ffff8800b6e4b200[47]: ffff8800b6786e00: 0000000000604840 0 1000 0
[ 3048.065813] aio_complete: added to ring ffff8800b6786e00 at [47]
[ 3048.065816] aio_complete: ffff8800b6e4b200[48]: ffff8800b6786e00: 0000000000604880 0 1000 0
[ 3048.065817] aio_complete: added to ring ffff8800b6786e00 at [48]
[ 3048.065820] aio_complete: ffff8800b6e4b200[49]: ffff8800b6786e00: 00000000006048c0 0 1000 0
[ 3048.065820] aio_complete: added to ring ffff8800b6786e00 at [49]
[ 3048.065824] aio_complete: ffff8800b6e4b200[50]: ffff8800b6786e00: 0000000000604900 0 1000 0
[ 3048.065825] aio_complete: added to ring ffff8800b6786e00 at [50]
[ 3048.065827] aio_complete: ffff8800b6e4b200[51]: ffff8800b6786e00: 0000000000604940 0 1000 0
[ 3048.065828] aio_complete: added to ring ffff8800b6786e00 at [51]
[ 3048.065831] aio_complete: ffff8800b6e4b200[52]: ffff8800b6786e00: 0000000000604980 0 1000 0
[ 3048.065832] aio_complete: added to ring ffff8800b6786e00 at [52]
[ 3048.065834] aio_complete: ffff8800b6e4b200[53]: ffff8800b6786e00: 00000000006049c0 0 1000 0
[ 3048.065835] aio_complete: added to ring ffff8800b6786e00 at [53]
[ 3048.065838] aio_complete: ffff8800b6e4b200[54]: ffff8800b6786e00: 0000000000604a00 0 1000 0
[ 3048.065839] aio_complete: added to ring ffff8800b6786e00 at [54]
[ 3048.065842] aio_complete: ffff8800b6e4b200[55]: ffff8800b6786e00: 0000000000604a40 0 1000 0
[ 3048.065843] aio_complete: added to ring ffff8800b6786e00 at [55]
[ 3048.065858] aio_complete: ffff8800b6e4b200[56]: ffff8800b6786e00: 0000000000604a80 0 1000 0
[ 3048.065860] aio_complete: added to ring ffff8800b6786e00 at [56]
[ 3048.065865] aio_complete: ffff8800b6e4b200[57]: ffff8800b6786e00: 0000000000604ac0 0 1000 0
[ 3048.065866] aio_complete: added to ring ffff8800b6786e00 at [57]
[ 3048.065870] aio_complete: ffff8800b6e4b200[58]: ffff8800b6786e00: 0000000000604b00 0 1000 0
[ 3048.065870] aio_complete: added to ring ffff8800b6786e00 at [58]
[ 3048.065873] aio_complete: ffff8800b6e4b200[59]: ffff8800b6786e00: 0000000000604b40 0 1000 0
[ 3048.065874] aio_complete: added to ring ffff8800b6786e00 at [59]
[ 3048.065877] aio_complete: ffff8800b6e4b200[60]: ffff8800b6786e00: 0000000000604b80 0 1000 0
[ 3048.065878] aio_complete: added to ring ffff8800b6786e00 at [60]
[ 3048.065881] aio_complete: ffff8800b6e4b200[61]: ffff8800b6786e00: 0000000000604bc0 0 1000 0
[ 3048.065882] aio_complete: added to ring ffff8800b6786e00 at [61]
[ 3048.065884] aio_complete: ffff8800b6e4b200[62]: ffff8800b6786e00: 0000000000604c00 0 1000 0
[ 3048.065885] aio_complete: added to ring ffff8800b6786e00 at [62]
[ 3048.065888] aio_complete: ffff8800b6e4b200[63]: ffff8800b6786e00: 0000000000604c40 0 1000 0
[ 3048.065889] aio_complete: added to ring ffff8800b6786e00 at [63]
[ 3048.065893] aio_complete: ffff8800b6e4b200[64]: ffff8800b6786e00: 0000000000604c80 0 1000 0
[ 3048.065894] aio_complete: added to ring ffff8800b6786e00 at [64]
[ 3048.066254] aio_complete: ffff8800b6e4b200[65]: ffff8800b6786e00: 0000000000604cc0 0 1000 0
[ 3048.066258] aio_complete: added to ring ffff8800b6786e00 at [65]
[ 3048.066269] aio_complete: ffff8800b6e4b200[66]: ffff8800b6786e00: 0000000000604d00 0 1000 0
[ 3048.066274] aio_complete: added to ring ffff8800b6786e00 at [66]
[ 3048.066284] aio_complete: ffff8800b6e4b200[67]: ffff8800b6786e00: 0000000000604d40 0 1000 0
[ 3048.066287] aio_complete: added to ring ffff8800b6786e00 at [67]
[ 3048.066298] aio_complete: ffff8800b6e4b200[68]: ffff8800b6786e00: 0000000000604d80 0 1000 0
[ 3048.066301] aio_complete: added to ring ffff8800b6786e00 at [68]
[ 3048.066312] aio_complete: ffff8800b6e4b200[69]: ffff8800b6786e00: 0000000000604dc0 0 1000 0
[ 3048.066315] aio_complete: added to ring ffff8800b6786e00 at [69]
[ 3048.066326] aio_complete: ffff8800b6e4b200[70]: ffff8800b6786e00: 0000000000604e00 0 1000 0
[ 3048.066329] aio_complete: added to ring ffff8800b6786e00 at [70]
[ 3048.066340] aio_complete: ffff8800b6e4b200[71]: ffff8800b6786e00: 0000000000604e40 0 1000 0
[ 3048.066343] aio_complete: added to ring ffff8800b6786e00 at [71]
[ 3048.066354] aio_complete: ffff8800b6e4b200[72]: ffff8800b6786e00: 0000000000604e80 0 1000 0
[ 3048.066357] aio_complete: added to ring ffff8800b6786e00 at [72]
[ 3048.066370] aio_complete: ffff8800b6e4b200[73]: ffff8800b6786e00: 0000000000604ec0 0 1000 0
[ 3048.066373] aio_complete: added to ring ffff8800b6786e00 at [73]
[ 3048.066383] aio_complete: ffff8800b6e4b200[74]: ffff8800b6786e00: 0000000000604f00 0 1000 0
[ 3048.066387] aio_complete: added to ring ffff8800b6786e00 at [74]
[ 3048.066398] aio_complete: ffff8800b6e4b200[75]: ffff8800b6786e00: 0000000000604f40 0 1000 0
[ 3048.066401] aio_complete: added to ring ffff8800b6786e00 at [75]
[ 3048.066412] aio_complete: ffff8800b6e4b200[76]: ffff8800b6786e00: 0000000000604f80 0 1000 0
[ 3048.066416] aio_complete: added to ring ffff8800b6786e00 at [76]
[ 3048.066426] aio_complete: ffff8800b6e4b200[77]: ffff8800b6786e00: 0000000000604fc0 0 1000 0
[ 3048.066432] aio_complete: added to ring ffff8800b6786e00 at [77]
[ 3048.066446] aio_complete: ffff8800b6e4b200[78]: ffff8800b6786e00: 0000000000605000 0 1000 0
[ 3048.066449] aio_complete: added to ring ffff8800b6786e00 at [78]
[ 3048.066460] aio_complete: ffff8800b6e4b200[79]: ffff8800b6786e00: 0000000000605040 0 1000 0
[ 3048.066463] aio_complete: added to ring ffff8800b6786e00 at [79]
[ 3048.066474] aio_complete: ffff8800b6e4b200[80]: ffff8800b6786e00: 0000000000605080 0 1000 0
[ 3048.066477] aio_complete: added to ring ffff8800b6786e00 at [80]
[ 3048.066488] aio_complete: ffff8800b6e4b200[81]: ffff8800b6786e00: 00000000006050c0 0 1000 0
[ 3048.066492] aio_complete: added to ring ffff8800b6786e00 at [81]
[ 3048.066502] aio_complete: ffff8800b6e4b200[82]: ffff8800b6786e00: 0000000000605100 0 1000 0
[ 3048.066507] aio_complete: added to ring ffff8800b6786e00 at [82]
[ 3048.066518] aio_complete: ffff8800b6e4b200[83]: ffff8800b6786e00: 0000000000605140 0 1000 0
[ 3048.066521] aio_complete: added to ring ffff8800b6786e00 at [83]
[ 3048.066532] aio_complete: ffff8800b6e4b200[84]: ffff8800b6786e00: 0000000000605180 0 1000 0
[ 3048.066536] aio_complete: added to ring ffff8800b6786e00 at [84]
[ 3048.066547] aio_complete: ffff8800b6e4b200[85]: ffff8800b6786e00: 00000000006051c0 0 1000 0
[ 3048.066550] aio_complete: added to ring ffff8800b6786e00 at [85]
[ 3048.066561] aio_complete: ffff8800b6e4b200[86]: ffff8800b6786e00: 0000000000605200 0 1000 0
[ 3048.066565] aio_complete: added to ring ffff8800b6786e00 at [86]
[ 3048.066576] aio_complete: ffff8800b6e4b200[87]: ffff8800b6786e00: 0000000000605240 0 1000 0
[ 3048.066579] aio_complete: added to ring ffff8800b6786e00 at [87]
[ 3048.066590] aio_complete: ffff8800b6e4b200[88]: ffff8800b6786e00: 0000000000605280 0 1000 0
[ 3048.066594] aio_complete: added to ring ffff8800b6786e00 at [88]
[ 3048.066605] aio_complete: ffff8800b6e4b200[89]: ffff8800b6786e00: 00000000006052c0 0 1000 0
[ 3048.066608] aio_complete: added to ring ffff8800b6786e00 at [89]
[ 3048.066619] aio_complete: ffff8800b6e4b200[90]: ffff8800b6786e00: 0000000000605300 0 1000 0
[ 3048.066623] aio_complete: added to ring ffff8800b6786e00 at [90]
[ 3048.066633] aio_complete: ffff8800b6e4b200[91]: ffff8800b6786e00: 0000000000605340 0 1000 0
[ 3048.066638] aio_complete: added to ring ffff8800b6786e00 at [91]
[ 3048.066652] aio_complete: ffff8800b6e4b200[92]: ffff8800b6786e00: 0000000000605380 0 1000 0
[ 3048.066655] aio_complete: added to ring ffff8800b6786e00 at [92]
[ 3048.066666] aio_complete: ffff8800b6e4b200[93]: ffff8800b6786e00: 00000000006053c0 0 1000 0
[ 3048.066670] aio_complete: added to ring ffff8800b6786e00 at [93]
[ 3048.066681] aio_complete: ffff8800b6e4b200[94]: ffff8800b6786e00: 0000000000605400 0 1000 0
[ 3048.066684] aio_complete: added to ring ffff8800b6786e00 at [94]
[ 3048.066696] aio_complete: ffff8800b6e4b200[95]: ffff8800b6786e00: 0000000000605440 0 1000 0
[ 3048.066699] aio_complete: added to ring ffff8800b6786e00 at [95]
[ 3048.066716] aio_complete: ffff8800b6e4b200[96]: ffff8800b6786e00: 0000000000605480 0 1000 0
[ 3048.066720] aio_complete: added to ring ffff8800b6786e00 at [96]
[ 3048.066731] aio_complete: ffff8800b6e4b200[97]: ffff8800b6786e00: 00000000006054c0 0 1000 0
[ 3048.066734] aio_complete: added to ring ffff8800b6786e00 at [97]
[ 3048.066745] aio_complete: ffff8800b6e4b200[98]: ffff8800b6786e00: 0000000000605500 0 1000 0
[ 3048.066750] aio_complete: added to ring ffff8800b6786e00 at [98]
[ 3048.066761] aio_complete: ffff8800b6e4b200[99]: ffff8800b6786e00: 0000000000605540 0 1000 0
[ 3048.066764] aio_complete: added to ring ffff8800b6786e00 at [99]
[ 3048.066775] aio_complete: ffff8800b6e4b200[100]: ffff8800b6786e00: 0000000000605580 0 1000 0
[ 3048.066779] aio_complete: added to ring ffff8800b6786e00 at [100]
[ 3048.066790] aio_complete: ffff8800b6e4b200[101]: ffff8800b6786e00: 00000000006055c0 0 1000 0
[ 3048.066794] aio_complete: added to ring ffff8800b6786e00 at [101]
[ 3048.066805] aio_complete: ffff8800b6e4b200[102]: ffff8800b6786e00: 0000000000605600 0 1000 0
[ 3048.066808] aio_complete: added to ring ffff8800b6786e00 at [102]
[ 3048.066820] aio_complete: ffff8800b6e4b200[103]: ffff8800b6786e00: 0000000000605640 0 1000 0
[ 3048.066823] aio_complete: added to ring ffff8800b6786e00 at [103]
[ 3048.066834] aio_complete: ffff8800b6e4b200[104]: ffff8800b6786e00: 0000000000605680 0 1000 0
[ 3048.066837] aio_complete: added to ring ffff8800b6786e00 at [104]
[ 3048.066848] aio_complete: ffff8800b6e4b200[105]: ffff8800b6786e00: 00000000006056c0 0 1000 0
[ 3048.067233] aio_complete: added to ring ffff8800b6786e00 at [105]
[ 3048.067850] aio_complete: ffff8800b6e4b200[106]: ffff8800b6786e00: 0000000000605700 0 1000 0
[ 3048.067855] aio_complete: added to ring ffff8800b6786e00 at [106]
[ 3048.067868] aio_complete: ffff8800b6e4b200[107]: ffff8800b6786e00: 0000000000605740 0 1000 0
[ 3048.067872] aio_complete: added to ring ffff8800b6786e00 at [107]
[ 3048.067883] aio_complete: ffff8800b6e4b200[108]: ffff8800b6786e00: 0000000000605780 0 1000 0
[ 3048.067886] aio_complete: added to ring ffff8800b6786e00 at [108]
[ 3048.067897] aio_complete: ffff8800b6e4b200[109]: ffff8800b6786e00: 00000000006057c0 0 1000 0
[ 3048.067901] aio_complete: added to ring ffff8800b6786e00 at [109]
[ 3048.067911] aio_complete: ffff8800b6e4b200[110]: ffff8800b6786e00: 0000000000605800 0 1000 0
[ 3048.067915] aio_complete: added to ring ffff8800b6786e00 at [110]
[ 3048.067926] aio_complete: ffff8800b6e4b200[111]: ffff8800b6786e00: 0000000000605840 0 1000 0
[ 3048.067930] aio_complete: added to ring ffff8800b6786e00 at [111]
[ 3048.067941] aio_complete: ffff8800b6e4b200[112]: ffff8800b6786e00: 0000000000605880 0 1000 0
[ 3048.067956] aio_complete: added to ring ffff8800b6786e00 at [112]
[ 3048.067973] aio_complete: ffff8800b6e4b200[113]: ffff8800b6786e00: 00000000006058c0 0 1000 0
[ 3048.067983] aio_complete: added to ring ffff8800b6786e00 at [113]
[ 3048.068000] aio_complete: ffff8800b6e4b200[114]: ffff8800b6786e00: 0000000000605900 0 1000 0
[ 3048.068010] aio_complete: added to ring ffff8800b6786e00 at [114]
[ 3048.068266] aio_complete: ffff8800b6e4b200[115]: ffff8800b6786e00: 0000000000605940 0 1000 0
[ 3048.068275] aio_complete: added to ring ffff8800b6786e00 at [115]
[ 3048.068292] aio_complete: ffff8800b6e4b200[116]: ffff8800b6786e00: 0000000000605980 0 1000 0
[ 3048.068301] aio_complete: added to ring ffff8800b6786e00 at [116]
[ 3048.068320] aio_complete: ffff8800b6e4b200[117]: ffff8800b6786e00: 00000000006059c0 0 1000 0
[ 3048.068323] aio_complete: added to ring ffff8800b6786e00 at [117]
[ 3048.068334] aio_complete: ffff8800b6e4b200[118]: ffff8800b6786e00: 0000000000605a00 0 1000 0
[ 3048.068337] aio_complete: added to ring ffff8800b6786e00 at [118]
[ 3048.068348] aio_complete: ffff8800b6e4b200[119]: ffff8800b6786e00: 0000000000605a40 0 1000 0
[ 3048.068351] aio_complete: added to ring ffff8800b6786e00 at [119]
[ 3048.068366] aio_complete: ffff8800b6e4b200[120]: ffff8800b6786e00: 0000000000605a80 0 1000 0
[ 3048.068370] aio_complete: added to ring ffff8800b6786e00 at [120]
[ 3048.068381] aio_complete: ffff8800b6e4b200[121]: ffff8800b6786e00: 0000000000605ac0 0 1000 0
[ 3048.068384] aio_complete: added to ring ffff8800b6786e00 at [121]
[ 3048.068395] aio_complete: ffff8800b6e4b200[122]: ffff8800b6786e00: 0000000000605b00 0 1000 0
[ 3048.068399] aio_complete: added to ring ffff8800b6786e00 at [122]
[ 3048.068410] aio_complete: ffff8800b6e4b200[123]: ffff8800b6786e00: 0000000000605b40 0 1000 0
[ 3048.068414] aio_complete: added to ring ffff8800b6786e00 at [123]
[ 3048.068436] aio_complete: ffff8800b6e4b200[124]: ffff8800b6786e00: 0000000000605b80 0 1000 0
[ 3048.068444] aio_complete: added to ring ffff8800b6786e00 at [124]
[ 3048.068462] aio_complete: ffff8800b6e4b200[125]: ffff8800b6786e00: 0000000000605bc0 0 1000 0
[ 3048.068472] aio_complete: added to ring ffff8800b6786e00 at [125]
[ 3048.068489] aio_complete: ffff8800b6e4b200[126]: ffff8800b6786e00: 0000000000605c00 0 1000 0
[ 3048.068498] aio_complete: added to ring ffff8800b6786e00 at [126]
[ 3048.068658] aio_read_events_ring: h0 t126 m127
[ 3048.068664] aio_read_events_ring: 126  h126 t126
[ 3048.068717] aio_complete: ffff8800b6e4b200[0]: ffff8800b6786e00: 0000000000605c40 0 1000 0
[ 3048.068721] aio_complete: added to ring ffff8800b6786e00 at [0]
[ 3048.068733] aio_complete: ffff8800b6e4b200[1]: ffff8800b6786e00: 0000000000605c80 0 1000 0
[ 3048.068736] aio_complete: added to ring ffff8800b6786e00 at [1]
[ 3048.068757] aio_read_events_ring: h126 t1 m127
[ 3048.068761] aio_read_events_ring: 2  h1 t1
[ 3048.079517] free_ioctx: freeing ffff8800b6e4b200
[ 3048.079525] aio_free_ring: pid(1005) [0] page->count=2

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="aio_bug.c"

/*
 * aio_bug.c
 *
 * Copyright (C) 2014, Dan Aloni, Kernelim Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 */

#include <assert.h>
#include <errno.h>
#include <libaio.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>

#define MAX_IOS 128

const int max_events = 32;
const int io_size = 0x1000;
io_context_t io_ctx;
struct iocb io[MAX_IOS];
struct iocb *iops[MAX_IOS];
struct iovec iovecs[MAX_IOS];
struct io_event events[MAX_IOS];
char *data;

long submitted = 0;
long completed = 0;
long pending = 0;

void prune(void)
{
	int ret;

        ret = io_getevents(io_ctx, pending, MAX_IOS, events, NULL);
	if (ret > 0) {
		printf("Completed: %d\n", ret);
		completed += ret;
		pending -= ret;
	}
}

int main(int argc, char **argv)
{
	int ret;
	int fd;
	const char *filename = "aio_bug_temp";
	long i, to_submit;
	struct iocb **iocb_sub;

	ret = io_setup(max_events, &io_ctx);
	assert(!ret);

	unlink(filename);
	fd = open(filename, O_CREAT | O_RDWR | O_DIRECT, 0644);
	assert(fd >= 0);

	ret = ftruncate(fd, MAX_IOS * io_size);
	assert(!ret);

	data = mmap(NULL, io_size * MAX_IOS, PROT_READ | PROT_WRITE,
		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	assert(data != MAP_FAILED);

	for (i = 0; i < MAX_IOS; i++) {
		iops[i] = &io[i];
		io[i].data = io;
		iovecs[i].iov_base = &data[io_size * i];
		iovecs[i].iov_len = io_size;
		io_prep_preadv(&io[i], fd, &iovecs[i], 1, 0);
	}

	to_submit = MAX_IOS;
	iocb_sub = iops;

	while (submitted < MAX_IOS) {
		printf("Submitting: %ld\n", to_submit);

		ret = io_submit(io_ctx, to_submit, iocb_sub);
		if (ret >= 0) {
			printf("Submitted: %d\n", ret);
			submitted += ret;
			iocb_sub += ret;
			pending += ret;
			to_submit -= ret;
		} else {
			if (ret == -EAGAIN) {
				printf("Submitted too much, that's okay\n");
				prune();
			}
		}
	}

	prune();
	io_destroy(io_ctx);

	close(fd);

	printf("Verifying...\n");

	assert(completed == submitted);

	printf("OK\n");

	return 0;
}

/*
 *
 * Good output:
 *
 *   Submitting: 128
 *   Submitted: 126
 *   Submitting: 2
 *   Submitted too much, that's okay
 *   Completed: 126
 *   Submitting: 2
 *   Submitted: 2
 *   Completed: 2
 *   Verifying...
 *   OK
 *
 * Bad output:
 *
 *   Submitting: 128
 *   Submitted: 128
 *   <program stuck, IO/s swallowed>
 *
 */

--RnlQjJ0d97Da+TV1--
