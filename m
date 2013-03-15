Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3COLDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:03:32 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:54292 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753921Ab3COLD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:03:29 -0400
Message-ID: <5142FFFF.7050301@mimc.co.uk>
Date: Fri, 15 Mar 2013 11:03:27 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: AM335x crc32 oops ?
References: <5134CEF9.5070502@mimc.co.uk>  <1363087506.3348.62.camel@sauron.fi.intel.com>  <51405F3A.3090901@mimc.co.uk>  <1363252425.11441.94.camel@sauron.fi.intel.com>  <51419E3A.8030007@mimc.co.uk>  <1363257009.11441.97.camel@sauron.fi.intel.com>  <5141B154.6050504@mimc.co.uk>  <1363260202.11441.108.camel@sauron.fi.intel.com>  <5141BC63.6060501@mimc.co.uk>  <1363263529.11441.109.camel@sauron.fi.intel.com> <1363263812.11441.112.camel@sauron.fi.intel.com> <5141D351.8060901@mimc.co.uk>
In-Reply-To: <5141D351.8060901@mimc.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the long email ...

Following on from another thread, I have encountered an issue with crc32 within
the mtd system, seemingly only on my AM335x cpu board.

In function ubi_eba_atomic_leb_change() in drivers/mtd/ubi/eba.c, there is a call
to crc32.

During a remount of my ubifs volume, ubi_eba_atomic_leb_change() is called several
times, with crc32 happening at various points.

Most of the time, the crc length is 2048 bytes, but when a large crc is required
(in my case 122880 bytes), I get an oops.

# mount -o remount,rw /
[   24.609350] UBIFS: start fixing up free space
[   24.627010] uealc crc32 : d08cb000 2048
[   24.643019] uealc crc32 : d08cb000 2048
[   24.661278] uealc crc32 : d08cb000 2048
[   24.680505] uealc crc32 : d08cb000 2048
[   24.743176] uealc crc32 : d08cb000 122880
[   24.747581] Unable to handle kernel paging request at virtual address e7938204
[   24.755199] pgd = cf408000
[   24.758052] [e7938204] *pgd=00000000
[   24.761833] Internal error: Oops: 5 [#1] ARM
[   24.766342] CPU: 0    Not tainted  (3.8.0-next-20130225-00002-g678576f-dirty #45)
[   24.774248] PC is at crc32_le+0xf8/0x168
[   24.778389] LR is at ubi_eba_atomic_leb_change+0x1d8/0x460
[   24.784177] pc : [<c01e734c>]    lr : [<c026de20>]    psr: 20000013
[   24.784177] sp : cf359e10  ip : 00003145  fp : c054f840
[   24.796285] r10: e7938104  r9 : c054fc40  r8 : af5e2a9e
[   24.801796] r7 : e59f3038  r6 : e59f0040  r5 : 00000040  r4 : 000000e5
[   24.808682] r3 : c054e040  r2 : 00000000  r1 : d08d05d0  r0 : 3e5ed77d
[   24.815570] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   24.823097] Control: 10c5387d  Table: 8f408019  DAC: 00000015
[   24.829160] Process mount (pid: 659, stack limit = 0xcf358238)
[   24.835313] Stack: (0xcf359e10 to 0xcf35a000)
[   24.839912] 9e00:                                     d08cb000 00000000 d08caffc 00003c00
[   24.848543] 9e20: cf2f8000 00000000 cf2ec000 cf32da00 cf2f8554 00000000 0000000c d08cb000
[   24.857173] 9e40: d08cb000 c059f1f6 cf32da00 00000000 00000000 00000000 00000000 0001e000
[   24.865803] 9e60: cf32e000 0000000c d08cb000 00000080 0000000c cf3c8f88 00000000 00000020
[   24.874435] 9e80: 00008000 c026c47c 0001e000 cf359e9c cf32e000 d08cb000 0001e000 c0179b80
[   24.883066] 9ea0: cf390c80 00000001 0001e000 cf32e000 00000000 cf32eb20 0000000c c01796f0
[   24.891698] 9ec0: cf32e000 00000000 cf32ea9c 00000000 cf359f48 c0175170 00000001 60000013
[   24.900329] 9ee0: cf326800 00000000 00000000 00000000 cf359f48 00000000 00000020 c00c9e24
[   24.908963] 9f00: 00100100 00200200 cf390c80 00008000 cf358000 00208020 00000000 cf01a200
[   24.917595] 9f20: cf326800 c00e3d6c 00000000 0000000c cf326840 00000000 c0013968 cf3c4680
[   24.926227] 9f40: 0000000c 00000000 cf01a210 ce828858 0000000c cf3a4000 000a18b4 00000000
[   24.934859] 9f60: 00208020 c0013968 cf358000 00000000 00000003 c00e3e40 00000000 c0071e24
[   24.943491] 9f80: 00000000 00000000 cf3c4680 cf314540 a0000010 00000000 be984b68 b6fbc48c
[   24.952124] 9fa0: 00000015 c00137c0 00000000 be984b68 000a18b4 000a18c0 000a18c2 00208020
[   24.960757] 9fc0: 00000000 be984b68 b6fbc48c 00000015 00000000 00000000 00000000 00000003
[   24.969391] 9fe0: b6f6ef48 be984a64 00042994 b6f6ef58 a0000010 000a18b4 ebfecd47 00095348
[   24.978033] [<c01e734c>] (crc32_le+0xf8/0x168) from [<d08cb000>] (0xd08cb000)
[   24.985570] Code: 0a000008 e59da008 e28a1003 e5f1c001 (e2522001)
[   24.992006] ---[ end trace 1496ae984fb21f1a ]---

I did some further testing, and, when the 122880 byte crc is about to run, I performed multiple
crc's on the same buffer but with increasing sizes:-

# mount -o remount,rw /
[   19.208302] UBIFS: start fixing up free space
[   19.230271] uealc crc32 : ** starting 122880 byte test **
[   19.235881] uealc crc32 : d08cb000 2048
[   19.240015] uealc crc32 : d08cb000 4096
[   19.244091] uealc crc32 : d08cb000 8192
[   19.248184] uealc crc32 : d08cb000 16384
[   19.252448] uealc crc32 : d08cb000 32768
[   19.256772] uealc crc32 : d08cb000 65536
[   19.260133] uealc crc32 : d08cb000 122880
[   19.261117] Unable to handle kernel paging request at virtual address e79381bc
[   19.268741] pgd = cf40c000
[   19.271598] [e79381bc] *pgd=00000000
[   19.275387] Internal error: Oops: 5 [#1] ARM
[   19.279902] CPU: 0    Not tainted  (3.8.0-next-20130225-00002-g678576f-dirty #47)
[   19.287819] PC is at crc32_le+0xf8/0x168
[   19.291965] LR is at ubi_eba_atomic_leb_change+0x3ac/0x4f8
[   19.297760] pc : [<c01e724c>]    lr : [<c026def4>]    psr: 20000013
[   19.297760] sp : cf3bbe08  ip : 00000e4e  fp : c054f840
[   19.309882] r10: e7938104  r9 : c054fc40  r8 : 65e95c1c
[   19.315396] r7 : 322e315f  r6 : 352e332e  r5 : 0000002e  r4 : 00000035
[   19.322288] r3 : c054e040  r2 : 00000033  r1 : d08d3d90  r0 : 63c3884e
[   19.329180] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   19.336713] Control: 10c5387d  Table: 8f40c019  DAC: 00000015
[   19.342781] Process mount (pid: 659, stack limit = 0xcf3ba238)
[   19.348939] Stack: (0xcf3bbe08 to 0xcf3bc000)
[   19.353542] be00:                   cf2f8554 00000000 d08caffc 00002000 cf2f8000 cf357a00
[   19.362183] be20: 00000000 0000000c cf2ec000 00000000 0000000c cf2f8554 00000000 00000000
[   19.370823] be40: d08cb000 d08cb000 00000000 07000000 00008000 c026c168 00000000 0001e000
[   19.379463] be60: 00000000 0000000c d08cb000 00000080 0000000c cf3bbf48 00000000 00000020
[   19.388101] be80: 00008000 c026c37c 0001e000 cf330000 cf330000 d08cb000 0001e000 c0179a78
[   19.396738] bea0: 0000000d c0177a68 0001e000 cf330000 00000000 cf330b20 0000000d c01794b4
[   19.405376] bec0: 00000000 cf330000 00000000 cf330a9c 00000000 c0175170 00000001 60000013
[   19.414012] bee0: cf32c800 00000000 00000000 00000000 cf3bbf48 00000000 00000020 c00c9e24
[   19.422648] bf00: 00100100 00200200 cf390300 00008000 cf3ba000 00208020 00000000 cf01a200
[   19.431284] bf20: cf32c800 c00e3d6c 00000000 0000000c cf32c840 00000000 c0013968 cf325800
[   19.439921] bf40: 0000000c 00000000 cf01a210 ce828858 0000000c cf053000 000a18b4 00000000
[   19.448559] bf60: 00208020 c0013968 cf3ba000 00000000 00000003 c00e3e40 00000000 c0071e24
[   19.457197] bf80: 00000000 00000000 cf325800 cf328380 a0000010 00000000 beb83b68 b6f8348c
[   19.465838] bfa0: 00000015 c00137c0 00000000 beb83b68 000a18b4 000a18c0 000a18c2 00208020
[   19.474475] bfc0: 00000000 beb83b68 b6f8348c 00000015 00000000 00000000 00000000 00000003
[   19.483108] bfe0: b6f35f48 beb83a64 00042994 b6f35f58 a0000010 000a18b4 00000000 00000000
[   19.491758] [<c01e724c>] (crc32_le+0xf8/0x168) from [<00000000>] (  (null))
[   19.499115] Code: 0a000008 e59da008 e28a1003 e5f1c001 (e2522001)
[   19.505555] ---[ end trace 84a04423f0bc8388 ]---

And then with finer size increases:-

# mount -o remount,rw /
[   25.161875] UBIFS: start fixing up free space
[   25.185334] uealc crc32 : ** starting 122880 byte test **
[   25.189572] uealc crc32 : d08cb000 1024
[   25.193653] uealc crc32 : d08cb000 2048
[   25.197709] uealc crc32 : d08cb000 3072
[   25.201819] uealc crc32 : d08cb000 4096
[   25.205886] uealc crc32 : d08cb000 5120
[   25.209982] uealc crc32 : d08cb000 6144
[   25.214054] uealc crc32 : d08cb000 7168
[   25.218129] uealc crc32 : d08cb000 8192
[   25.222238] uealc crc32 : d08cb000 9216
[   25.226323] uealc crc32 : d08cb000 10240
[   25.230528] uealc crc32 : d08cb000 11264
[   25.234711] uealc crc32 : d08cb000 12288
[   25.238928] uealc crc32 : d08cb000 13312
[   25.243119] uealc crc32 : d08cb000 14336
[   25.247313] uealc crc32 : d08cb000 15360
[   25.251541] uealc crc32 : d08cb000 16384
[   25.255744] uealc crc32 : d08cb000 17408
[   25.259982] uealc crc32 : d08cb000 18432
[   25.264193] uealc crc32 : d08cb000 19456
[   25.268406] uealc crc32 : d08cb000 20480
[   25.272657] uealc crc32 : d08cb000 21504
[   25.276881] uealc crc32 : d08cb000 22528
[   25.281136] uealc crc32 : d08cb000 23552
[   25.285367] uealc crc32 : d08cb000 24576
[   25.289633] uealc crc32 : d08cb000 25600
[   25.293873] uealc crc32 : d08cb000 26624
[   25.298115] uealc crc32 : d08cb000 27648
[   25.302394] uealc crc32 : d08cb000 28672
[   25.306644] uealc crc32 : d08cb000 29696
[   25.310928] uealc crc32 : d08cb000 30720
[   25.315188] uealc crc32 : d08cb000 31744
[   25.319485] uealc crc32 : d08cb000 32768
[   25.323753] uealc crc32 : d08cb000 33792
[   25.328025] uealc crc32 : d08cb000 34816
[   25.332331] uealc crc32 : d08cb000 35840
[   25.336612] uealc crc32 : d08cb000 36864
[   25.340924] uealc crc32 : d08cb000 37888
[   25.345212] uealc crc32 : d08cb000 38912
[   25.349538] uealc crc32 : d08cb000 39936
[   25.353837] uealc crc32 : d08cb000 40960
[   25.358138] uealc crc32 : d08cb000 41984
[   25.362481] uealc crc32 : d08cb000 43008
[   25.366794] uealc crc32 : d08cb000 44032
[   25.371140] uealc crc32 : d08cb000 45056
[   25.375462] uealc crc32 : d08cb000 46080
[   25.379823] uealc crc32 : d08cb000 47104
[   25.384155] uealc crc32 : d08cb000 48128
[   25.388490] uealc crc32 : d08cb000 49152
[   25.392862] uealc crc32 : d08cb000 50176
[   25.397207] uealc crc32 : d08cb000 51200
[   25.401583] uealc crc32 : d08cb000 52224
[   25.405936] uealc crc32 : d08cb000 53248
[   25.410326] uealc crc32 : d08cb000 54272
[   25.414688] uealc crc32 : d08cb000 55296
[   25.419084] uealc crc32 : d08cb000 56320
[   25.423455] uealc crc32 : d08cb000 57344
[   25.427827] uealc crc32 : d08cb000 58368
[   25.432238] uealc crc32 : d08cb000 59392
[   25.436621] uealc crc32 : d08cb000 60416
[   25.441033] uealc crc32 : d08cb000 61440
[   25.445423] uealc crc32 : d08cb000 62464
[   25.449852] uealc crc32 : d08cb000 63488
[   25.454254] uealc crc32 : d08cb000 64512
[   25.458658] uealc crc32 : d08cb000 65536
[   25.463097] uealc crc32 : d08cb000 66560
[   25.467508] uealc crc32 : d08cb000 67584
[   25.471953] uealc crc32 : d08cb000 68608
[   25.476372] uealc crc32 : d08cb000 69632
[   25.480823] uealc crc32 : d08cb000 70656
[   25.485251] uealc crc32 : d08cb000 71680
[   25.489712] uealc crc32 : d08cb000 72704
[   25.494147] uealc crc32 : d08cb000 73728
[   25.498584] uealc crc32 : d08cb000 74752
[   25.503058] uealc crc32 : d08cb000 75776
[   25.507505] uealc crc32 : d08cb000 76800
[   25.511988] uealc crc32 : d08cb000 77824
[   25.516443] uealc crc32 : d08cb000 78848
[   25.520935] uealc crc32 : d08cb000 79872
[   25.525399] uealc crc32 : d08cb000 80896
[   25.529899] uealc crc32 : d08cb000 81920
[   25.534369] uealc crc32 : d08cb000 82944
[   25.538876] uealc crc32 : d08cb000 83968
[   25.543359] uealc crc32 : d08cb000 84992
[   25.547844] uealc crc32 : d08cb000 86016
[   25.552366] uealc crc32 : d08cb000 87040
[   25.556859] uealc crc32 : d08cb000 88064
[   25.561383] uealc crc32 : d08cb000 89088
[   25.565885] uealc crc32 : d08cb000 90112
[   25.570423] uealc crc32 : d08cb000 91136
[   25.574935] uealc crc32 : d08cb000 92160
[   25.579479] uealc crc32 : d08cb000 93184
[   25.583997] uealc crc32 : d08cb000 94208
[   25.588517] uealc crc32 : d08cb000 95232
[   25.593115] uealc crc32 : d08cb000 96256
[   25.597648] uealc crc32 : d08cb000 97280
[   25.602226] uealc crc32 : d08cb000 98304
[   25.606766] uealc crc32 : d08cb000 99328
[   25.611340] uealc crc32 : d08cb000 100352
[   25.615978] uealc crc32 : d08cb000 101376
[   25.620652] uealc crc32 : d08cb000 102400
[   25.625300] uealc crc32 : d08cb000 103424
[   25.629984] uealc crc32 : d08cb000 104448
[   25.634637] uealc crc32 : d08cb000 105472
[   25.639325] uealc crc32 : d08cb000 106496
[   25.643988] uealc crc32 : d08cb000 107520
[   25.648650] uealc crc32 : d08cb000 108544
[   25.653370] uealc crc32 : d08cb000 109568
[   25.658047] uealc crc32 : d08cb000 110592
[   25.662764] uealc crc32 : d08cb000 111616
[   25.667449] uealc crc32 : d08cb000 112640
[   25.672168] uealc crc32 : d08cb000 113664
[   25.676858] uealc crc32 : d08cb000 114688
[   25.681581] uealc crc32 : d08cb000 115712
[   25.686276] uealc crc32 : d08cb000 116736
[   25.691010] uealc crc32 : d08cb000 117760
[   25.695717] uealc crc32 : d08cb000 118784
[   25.700462] uealc crc32 : d08cb000 119808
[   25.705177] uealc crc32 : d08cb000 120832
[   25.709929] uealc crc32 : d08cb000 121856
[   25.714654] uealc crc32 : d08cb000 122880
[   25.719414] uealc crc x
[   27.527375] UBIFS: free space fixup complete
[   27.550760] UBIFS: background thread "ubifs_bgt0_0" started, PID 660

So it seems time related (??) in that if I do more testing before checking the full 122880
byte buffer, the crc works.

But if the buffer gets crc-ed too quickly, I get an oops.

Does anyone have *any* idea what's going on ?

Cheers
Mark J.
