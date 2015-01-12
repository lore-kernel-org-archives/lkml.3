Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbbALV5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:57:15 -0500
Received: from mail-db3on0081.outbound.protection.outlook.com ([157.55.234.81]:43770
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbbALV5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:57:14 -0500
Message-ID: <54B44326.6010501@ezchip.com>
Date: Mon, 12 Jan 2015 16:56:54 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2 22/40] tile: fix put_user sparse errors
References: <1420558883-10131-1-git-send-email-mst@redhat.com> <1420558883-10131-23-git-send-email-mst@redhat.com>
In-Reply-To: <1420558883-10131-23-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.216.194.146]
X-ClientProxiedBy: BLUPR07CA0032.namprd07.prod.outlook.com (10.255.223.145) To
 DB4PR02MB0543.eurprd02.prod.outlook.com (10.141.45.16)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=cmetcalf@ezchip.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DB4PR02MB0543;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB4PR02MB0543;
X-Forefront-PRVS: 0454444834
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(377454003)(51704005)(199003)(479174004)(24454002)(189002)(80316001)(106356001)(64126003)(19580395003)(42186005)(76176999)(50986999)(92566002)(65816999)(122386002)(83506001)(23746002)(97736003)(54356999)(64706001)(65956001)(66066001)(15975445007)(47776003)(46102003)(86362001)(62966003)(40100003)(77156002)(33656002)(50466002)(105586002)(65806001)(87976001)(36756003)(77096005)(68736005)(101416001)(2950100001)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB4PR02MB0543;H:[10.7.0.239];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB4PR02MB0543;
X-OriginatorOrg: ezchip.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 21:57:09.8788 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR02MB0543
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nack for this patch as-is.

On 1/6/2015 10:44 AM, Michael S. Tsirkin wrote:
> virtio wants to write bitwise types to userspace using put_user.
> At the moment this triggers sparse errors, since the value is passed
> through an integer.
>
> For example:
>
> 	__le32 __user *p;
> 	__le32 x;
> 	put_user(x, p);
>
> is safe, but currently triggers a sparse warning on tile.
>
> The reason has to do with this code:
> 	__typeof((x)-(x))
> which seems to be a way to force check for an integer type.

No, it's purely a way to avoid

   warning: cast from pointer to integer of different size

at every place we invoke put_user() with a pointer - which is
in fact pretty frequent throughout the kernel.  The idiom of
casting to the difference of the type converts it to a type
of the same size as the input (whether integral or pointer),
but guaranteed to be an integral type.  Then from there it's safe
to cast it on to a u64 without generating a warning.

I agree that letting sparse work correctly in this case seems
like an important goal.  But I don't think we can tolerate
adding a raft of warnings to the standard kernel build for this
case, and we also can't just delete the put_user_8 case altogether,
since it's used for various things even in 32-bit kernels.

I suppose we could do something like the following.  It's mildly
unfortunate that we'd lose out on some inlining optimization, though:

--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -244,24 +244,8 @@ extern int __get_user_bad(void)
  #define __put_user_1(x, ptr, ret) __put_user_asm(sb, x, ptr, ret)
  #define __put_user_2(x, ptr, ret) __put_user_asm(sh, x, ptr, ret)
  #define __put_user_4(x, ptr, ret) __put_user_asm(sw, x, ptr, ret)
-#define __put_user_8(x, ptr, ret)                                      \
-       ({                                                              \
-               u64 __x = (__typeof((x)-(x)))(x);                       \
-               int __lo = (int) __x, __hi = (int) (__x >> 32);         \
-               asm volatile("1: { sw %1, %2; addi %0, %1, 4 }\n"       \
-                            "2: { sw %0, %3; movei %0, 0 }\n"          \
-                            ".pushsection .fixup,\"ax\"\n"             \
-                            "0: { movei %0, %4; j 9f }\n"              \
-                            ".section __ex_table,\"a\"\n"              \
-                            ".align 4\n"                               \
-                            ".word 1b, 0b\n"                           \
-                            ".word 2b, 0b\n"                           \
-                            ".popsection\n"                            \
-                            "9:"                                       \
-                            : "=&r" (ret)                              \
-                            : "r" (ptr), "r" (__lo32(__lo, __hi)),     \
-                            "r" (__hi32(__lo, __hi)), "i" (-EFAULT));  \
-       })
+#define __put_user_8(x, ptr, ret) \
+  (ret = __copy_to_user_inatomic(ptr, &x, 8) == 0 ? 0 : -EFAULT)
  #endif

  extern int __put_user_bad(void)


> Since this is part of __put_user_8 which is only ever used
> for unsigned and signed char types, this seems unnecessary -
> I also note that no other architecture has such protections.

Maybe because none of the other 32-bit kernel architectures provide
a 64-bit inline for put_user().

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

