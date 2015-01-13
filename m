Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbbAMAKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 19:10:16 -0500
Received: from mail-am1on0056.outbound.protection.outlook.com ([157.56.112.56]:51664
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751489AbbAMAKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 19:10:12 -0500
Message-ID: <54B46204.1010003@ezchip.com>
Date: Mon, 12 Jan 2015 19:08:36 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2 23/40] tile: enable sparse checks for get/put_user
References: <1420558883-10131-1-git-send-email-mst@redhat.com> <1420558883-10131-24-git-send-email-mst@redhat.com>
In-Reply-To: <1420558883-10131-24-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.76.21.154]
X-ClientProxiedBy: BLUPR07CA0054.namprd07.prod.outlook.com (10.255.223.167) To
 DB3PR02MB0537.eurprd02.prod.outlook.com (25.160.51.149)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=cmetcalf@ezchip.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DB3PR02MB0537;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB3PR02MB0537;
X-Forefront-PRVS: 045584D28C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(199003)(51704005)(24454002)(189002)(479174004)(377454003)(76176999)(87266999)(54356999)(50466002)(50986999)(2950100001)(77096005)(65806001)(15975445007)(68736005)(92566002)(36756003)(42186005)(65816999)(23746002)(122386002)(105586002)(117156001)(59896002)(40100003)(83506001)(19580395003)(80316001)(19580405001)(46102003)(97736003)(47776003)(33656002)(66066001)(101416001)(87976001)(77156002)(62966003)(64706001)(86362001)(106356001)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR02MB0537;H:[192.168.1.160];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0537;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 00:08:45.6936 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR02MB0537
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR02MB0394;
X-OriginatorOrg: ezchip.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2015 10:44 AM, Michael S. Tsirkin wrote:
> Tile currently does not trigger sparse warnings when get_user
> causes an illegal assignment across bitwise types.
>
> For example:
>
> __le32 __user *p;
> __u32 x;
> put_user(x, p);
>
> violates endian-ness rules, but currently does not trigger sparse
> warning on tile.
>
> Fix this by adding some dead code.
>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>   arch/tile/include/asm/uaccess.h | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
> index 22cffa1..03d905c 100644
> --- a/arch/tile/include/asm/uaccess.h
> +++ b/arch/tile/include/asm/uaccess.h
> @@ -218,6 +218,8 @@ extern int __get_user_bad(void)
>   		case 8: __get_user_8(x, ptr, __ret); break;		\
>   		default: __ret = __get_user_bad(); break;		\
>   		}							\
> +		if (0)							\
> +			x = *(__force typeof(*ptr) *)(ptr);		\
>   		__ret;							\
>   	})

The "if (0)" suggestion is cute, but pretty hacky :-)

Here's a revised change that may fix both of your sparse concerns with
tile, without having to give up the optimized 64-bit get/put on tilepro.
Would this fix both the issue discussed in this change, as well as the
issue in the previous change (where you removed the typeof(x-x) cast)?

The key changes are to copy the x86 definition of __inttype(), and then to
arrange to use an intermediate integral type that gets assigned to or from
the actual typed value so as to expose any sparse issues.

If this works for you, I'm happy to queue it in the tile tree, or I can
provide a proper git commit for you to include in your series, whichever
works better for you.

--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -114,14 +114,14 @@ struct exception_table_entry {
  extern int fixup_exception(struct pt_regs *regs);

  /*
+ * This is a type: either unsigned long, if the argument fits into
+ * that type, or otherwise unsigned long long.
+ */
+#define __inttype(x) \
+       __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
+
+/*
   * Support macros for __get_user().
- *
- * Implementation note: The "case 8" logic of casting to the type of
- * the result of subtracting the value from itself is basically a way
- * of keeping all integer types the same, but casting any pointers to
- * ptrdiff_t, i.e. also an integer type.  This way there are no
- * questionable casts seen by the compiler on an ILP32 platform.
- *
   * Note that __get_user() and __put_user() assume proper alignment.
   */

@@ -178,7 +178,7 @@ extern int fixup_exception(struct pt_regs *regs);
                              "9:"                                       \
                              : "=r" (ret), "=r" (__a), "=&r" (__b)      \
                              : "r" (ptr), "i" (-EFAULT));               \
-               (x) = (__typeof(x))(__typeof((x)-(x)))                  \
+               (x) = (__typeof(x))(__inttype(x))                       \
                         (((u64)__hi32(__a, __b) << 32) |                \
                          __lo32(__a, __b));                             \
         })
@@ -210,14 +210,16 @@ extern int __get_user_bad(void)
  #define __get_user(x, ptr)                                             \
         ({                                                              \
                 int __ret;                                              \
+               __inttype(*(ptr)) __x;                                  \
                 __chk_user_ptr(ptr);                                    \
                 switch (sizeof(*(ptr))) {                               \
-               case 1: __get_user_1(x, ptr, __ret); break;             \
-               case 2: __get_user_2(x, ptr, __ret); break;             \
-               case 4: __get_user_4(x, ptr, __ret); break;             \
-               case 8: __get_user_8(x, ptr, __ret); break;             \
+               case 1: __get_user_1(__x, ptr, __ret); break;           \
+               case 2: __get_user_2(__x, ptr, __ret); break;           \
+               case 4: __get_user_4(__x, ptr, __ret); break;           \
+               case 8: __get_user_8(__x, ptr, __ret); break;           \
                 default: __ret = __get_user_bad(); break;               \
                 }                                                       \
+               (x) = (typeof(x))__x;                                   \
                 __ret;                                                  \
         })

@@ -246,7 +248,7 @@ extern int __get_user_bad(void)
  #define __put_user_4(x, ptr, ret) __put_user_asm(sw, x, ptr, ret)
  #define __put_user_8(x, ptr, ret)                                      \
         ({                                                              \
-               u64 __x = (__typeof((x)-(x)))(x);                       \
+               u64 __x = (__inttype(x))(x);                            \
                 int __lo = (int) __x, __hi = (int) (__x >> 32);         \
                 asm volatile("1: { sw %1, %2; addi %0, %1, 4 }\n"       \
                              "2: { sw %0, %3; movei %0, 0 }\n"          \
@@ -289,12 +291,13 @@ extern int __put_user_bad(void)
  #define __put_user(x, ptr)                                             \
  ({                                                                     \
         int __ret;                                                      \
+       typeof(*(ptr)) __x = (x);                                       \
         __chk_user_ptr(ptr);                                            \
         switch (sizeof(*(ptr))) {                                       \
-       case 1: __put_user_1(x, ptr, __ret); break;                     \
-       case 2: __put_user_2(x, ptr, __ret); break;                     \
-       case 4: __put_user_4(x, ptr, __ret); break;                     \
-       case 8: __put_user_8(x, ptr, __ret); break;                     \
+       case 1: __put_user_1(__x, ptr, __ret); break;                   \
+       case 2: __put_user_2(__x, ptr, __ret); break;                   \
+       case 4: __put_user_4(__x, ptr, __ret); break;                   \
+       case 8: __put_user_8(__x, ptr, __ret); break;                   \
         default: __ret = __put_user_bad(); break;                       \
         }                                                               \
         __ret;                                                          \
  

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

