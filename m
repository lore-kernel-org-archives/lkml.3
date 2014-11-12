Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418AbaKLDF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:05:58 -0500
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:10101
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933261AbaKLDFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:05:54 -0500
From: Long Li <longli@microsoft.com>
To: Peter Zijlstra <peterz@infradead.org>, Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Inconsistent lock state with Hyper-V memory balloon?
Thread-Topic: Inconsistent lock state with Hyper-V memory balloon?
Thread-Index: AQHP+2F8i9+cQP8y+EyeFYpfF56/nJxZnvqAgAK0nyA=
Date: Wed, 12 Nov 2014 03:05:49 +0000
Message-ID: <1db2a50b902f4b5c9f82ebd33c2e4e13@BL2PR03MB132.namprd03.prod.outlook.com>
References: <20141108143654.GA7939@sucs.org>
 <20141110094407.GE29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141110094407.GE29390@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ee31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;
x-forefront-prvs: 03932714EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(479174003)(377454003)(189002)(199003)(24454002)(13464003)(51704005)(15202345003)(40100003)(33646002)(46102003)(87936001)(2656002)(76576001)(101416001)(97736003)(19580395003)(19580405001)(62966003)(122556002)(74316001)(31966008)(77156002)(77096003)(92566001)(99936001)(50986999)(76176999)(120916001)(54356999)(108616004)(99396003)(107046002)(106116001)(105586002)(20776003)(106356001)(99286002)(86362001)(15975445006)(95666004)(21056001)(64706001)(4396001)(24736002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0709;H:BL2PR03MB132.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: multipart/mixed;
	boundary="_002_1db2a50b902f4b5c9f82ebd33c2e4e13BL2PR03MB132namprd03pro_"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0773;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1db2a50b902f4b5c9f82ebd33c2e4e13BL2PR03MB132namprd03pro_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Sitsofe, can you try the patch attached to see if it helps with the problem=
?=20

Long

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.ke=
rnel.org] On Behalf Of Peter Zijlstra
Sent: Monday, November 10, 2014 1:44 AM
To: Sitsofe Wheeler
Cc: KY Srinivasan; Haiyang Zhang; devel@linuxdriverproject.org; Ingo Molnar=
; linux-kernel@vger.kernel.org
Subject: Re: Inconsistent lock state with Hyper-V memory balloon?

On Sat, Nov 08, 2014 at 02:36:54PM +0000, Sitsofe Wheeler wrote:
> I've been trying to use the Hyper-V balloon driver to allow the host=20
> to reclaim unused memory but have been hitting issues. With a Hyper-V=20
> 2012
> R2 guest with 4GBytes of RAM, dynamic memory on, 1GByte minimum=20
> 10GByte maximum, 8 vcpus, running a 3.18.0-rc3 kernel with no swap=20
> configured the following lockdep splat occurred:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: inconsistent lock state ]
> 3.18.0-rc3.x86_64 #159 Not tainted
> ---------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
>  (bdev_lock){+.?...}, at: [<ffffffff811ff39c>]=20
> nr_blockdev_pages+0x1c/0x80 {SOFTIRQ-ON-W} state was registered at:
>   [<ffffffff810ba03d>] __lock_acquire+0x87d/0x1c60
>   [<ffffffff810bbcdc>] lock_acquire+0xfc/0x150
>   [<ffffffff816e4019>] _raw_spin_lock+0x39/0x50
>   [<ffffffff811ff39c>] nr_blockdev_pages+0x1c/0x80
>   [<ffffffff8115d5f7>] si_meminfo+0x47/0x70
>   [<ffffffff81d6622f>] eventpoll_init+0x11/0x10a
>   [<ffffffff81d3d150>] do_one_initcall+0xf9/0x1a7
>   [<ffffffff81d3d3d2>] kernel_init_freeable+0x1d4/0x268
>   [<ffffffff816ce0ae>] kernel_init+0xe/0x100
>   [<ffffffff816e4dfc>] ret_from_fork+0x7c/0xb0 irq event stamp:=20
> 2660283708 hardirqs last  enabled at (2660283708):=20
> [<ffffffff8115eef5>] free_hot_cold_page+0x175/0x190 hardirqs last=20
> disabled at (2660283707): [<ffffffff8115ee25>]=20
> free_hot_cold_page+0xa5/0x190 softirqs last  enabled at (2660132034):=20
> [<ffffffff81071e6a>] _local_bh_enable+0x4a/0x50 softirqs last disabled=20
> at (2660132035): [<ffffffff81072478>] irq_exit+0x58/0xc0
>=20
> might help us debug this:
>  Possible unsafe locking scenario:
>=20
>        CPU0
>        ----
>   lock(bdev_lock);
>   <Interrupt>
>     lock(bdev_lock);
>=20
> *
>=20
> no locks held by swapper/0/0.
>=20
>=20
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc3.x86_64 #159=20
> Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine,=20
> BIOS 090006  05/23/2012
>  ffffffff8266ac90 ffff880107403af8 ffffffff816db3ef 0000000000000000
>  ffffffff81c134c0 ffff880107403b58 ffffffff816d6fd3 0000000000000001
>  ffffffff00000001 ffff880100000000 ffffffff81010e6f 0000000000000046=20
> Call Trace:
>  <IRQ>  [<ffffffff816db3ef>] dump_stack+0x4e/0x68 =20
> [<ffffffff816d6fd3>] print_usage_bug+0x1f3/0x204  [<ffffffff81010e6f>]=20
> ? save_stack_trace+0x2f/0x50  [<ffffffff810b6f40>] ?=20
> print_irq_inversion_bug+0x200/0x200
>  [<ffffffff810b78e6>] mark_lock+0x176/0x2e0  [<ffffffff810b9f83>]=20
> __lock_acquire+0x7c3/0x1c60  [<ffffffff8103d548>] ?=20
> lookup_address+0x28/0x30  [<ffffffff8103d58b>] ?=20
> _lookup_address_cpa.isra.3+0x3b/0x40
>  [<ffffffff813c4e89>] ? __debug_check_no_obj_freed+0x89/0x220
>  [<ffffffff810bbcdc>] lock_acquire+0xfc/0x150  [<ffffffff811ff39c>] ?=20
> nr_blockdev_pages+0x1c/0x80  [<ffffffff816e4019>]=20
> _raw_spin_lock+0x39/0x50  [<ffffffff811ff39c>] ?=20
> nr_blockdev_pages+0x1c/0x80  [<ffffffff811ff39c>]=20
> nr_blockdev_pages+0x1c/0x80  [<ffffffff8115d5f7>] si_meminfo+0x47/0x70 =20
> [<ffffffff815eb14d>] post_status.isra.3+0x6d/0x190 =20
> [<ffffffff810b7f4d>] ? trace_hardirqs_on+0xd/0x10 =20
> [<ffffffff8115f00f>] ? __free_pages+0x2f/0x60  [<ffffffff815eb34f>] ?=20
> free_balloon_pages.isra.5+0x8f/0xb0
>  [<ffffffff815eb972>] balloon_onchannelcallback+0x212/0x380
>  [<ffffffff815e69d3>] vmbus_on_event+0x173/0x1d0  [<ffffffff81071b47>]=20
> tasklet_action+0x127/0x160  [<ffffffff81071ffa>]=20
> __do_softirq+0x18a/0x340  [<ffffffff81072478>] irq_exit+0x58/0xc0 =20
> [<ffffffff810290c5>] hyperv_vector_handler+0x45/0x60 =20
> [<ffffffff816e6b92>] hyperv_callback_vector+0x72/0x80  <EOI> =20
> [<ffffffff81037b76>] ? native_safe_halt+0x6/0x10  [<ffffffff810b7f4d>]=20
> ? trace_hardirqs_on+0xd/0x10  [<ffffffff8100c8d1>]=20
> default_idle+0x51/0xf0  [<ffffffff8100d30f>] arch_cpu_idle+0xf/0x20 =20
> [<ffffffff810b01e7>] cpu_startup_entry+0x217/0x3f0 =20
> [<ffffffff816ce099>] rest_init+0xc9/0xd0  [<ffffffff816cdfd5>] ?=20
> rest_init+0x5/0xd0  [<ffffffff81d3d04a>] start_kernel+0x438/0x445 =20
> [<ffffffff81d3c94a>] ? set_init_arg+0x57/0x57  [<ffffffff81d3c120>] ?=20
> early_idt_handlers+0x120/0x120  [<ffffffff81d3c59f>]=20
> x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff81d3c6df>] x86_64_start_kernel+0x13e/0x14d
>=20
> Any help deciphering the above is greatly appreciated!

Its fairly simple, the first trace shows where bdev_lock was taken with sof=
tirqs enabled, and the second trace shows where its taken from softirqs. Co=
mbine the two and you've got a recursive deadlock.

I don't know the block layer very well, but a quick glance at the code show=
s its bdev_lock isn't meant to be used from softirq context, therefore the =
hyperv stuff is broken.

So complain to the hyperv people.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in =
the body of a message to majordomo@vger.kernel.org More majordomo info at  =
http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--_002_1db2a50b902f4b5c9f82ebd33c2e4e13BL2PR03MB132namprd03pro_
Content-Type: application/octet-stream;
	name="0001-Move-unballoon-to-work-queue.patch"
Content-Description: 0001-Move-unballoon-to-work-queue.patch
Content-Disposition: attachment;
	filename="0001-Move-unballoon-to-work-queue.patch"; size=2587;
	creation-date="Tue, 11 Nov 2014 17:13:27 GMT";
	modification-date="Tue, 11 Nov 2014 17:13:27 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzOGUyNWMwZjdlOWUzOTBhMGVhY2Q0OGU5NjAyMDExNzI2ODM4OGYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT4KRGF0ZTog
VHVlLCAxMSBOb3YgMjAxNCAxNzoxMDoyMCArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIE1vdmUgdW5i
YWxsb29uIHRvIHdvcmsgcXVldWUKCi0tLQogZHJpdmVycy9odi9odl9iYWxsb29uLmMgfCAxNyAr
KysrKysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDYgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9odi9odl9iYWxsb29uLmMgYi9kcml2ZXJz
L2h2L2h2X2JhbGxvb24uYwppbmRleCA1ZTkwYzVkLi5kNWIxMWQ1IDEwMDY0NAotLS0gYS9kcml2
ZXJzL2h2L2h2X2JhbGxvb24uYworKysgYi9kcml2ZXJzL2h2L2h2X2JhbGxvb24uYwpAQCAtNTA5
LDYgKzUwOSw5IEBAIHN0cnVjdCBodl9keW5tZW1fZGV2aWNlIHsKIAkgKi8KIAlzdHJ1Y3QgYmFs
bG9vbl9zdGF0ZSBiYWxsb29uX3dyazsKIAorCXN0cnVjdCBkbV91bmJhbGxvb25fcmVxdWVzdCAq
dW5iYWxsb29uX3JlcTsKKwlzdHJ1Y3QgYmFsbG9vbl9zdGF0ZSB1bmJhbGxvb25fd3JrOworCiAJ
LyoKIAkgKiBTdGF0ZSB0byBleGVjdXRlIHRoZSAiaG90LWFkZCIgb3BlcmF0aW9uLgogCSAqLwpA
QCAtMTE1NywxNiArMTE2MCwxNiBAQCBzdGF0aWMgdm9pZCBiYWxsb29uX3VwKHN0cnVjdCB3b3Jr
X3N0cnVjdCAqZHVtbXkpCiAKIH0KIAotc3RhdGljIHZvaWQgYmFsbG9vbl9kb3duKHN0cnVjdCBo
dl9keW5tZW1fZGV2aWNlICpkbSwKLQkJCXN0cnVjdCBkbV91bmJhbGxvb25fcmVxdWVzdCAqcmVx
KQorc3RhdGljIHZvaWQgYmFsbG9vbl9kb3duKHN0cnVjdCB3b3JrX3N0cnVjdCAqZHVtbXkpCiB7
CisJc3RydWN0IGRtX3VuYmFsbG9vbl9yZXF1ZXN0ICpyZXEgPSBkbV9kZXZpY2UudW5iYWxsb29u
X3JlcTsKIAl1bmlvbiBkbV9tZW1fcGFnZV9yYW5nZSAqcmFuZ2VfYXJyYXkgPSByZXEtPnJhbmdl
X2FycmF5OwogCWludCByYW5nZV9jb3VudCA9IHJlcS0+cmFuZ2VfY291bnQ7CiAJc3RydWN0IGRt
X3VuYmFsbG9vbl9yZXNwb25zZSByZXNwOwogCWludCBpOwogCiAJZm9yIChpID0gMDsgaSA8IHJh
bmdlX2NvdW50OyBpKyspIHsKLQkJZnJlZV9iYWxsb29uX3BhZ2VzKGRtLCAmcmFuZ2VfYXJyYXlb
aV0pOworCQlmcmVlX2JhbGxvb25fcGFnZXMoJmRtX2RldmljZSwgJnJhbmdlX2FycmF5W2ldKTsK
IAkJcG9zdF9zdGF0dXMoJmRtX2RldmljZSk7CiAJfQogCkBAIC0xMTgzLDcgKzExODYsNyBAQCBz
dGF0aWMgdm9pZCBiYWxsb29uX2Rvd24oc3RydWN0IGh2X2R5bm1lbV9kZXZpY2UgKmRtLAogCQkJ
CSh1bnNpZ25lZCBsb25nKU5VTEwsCiAJCQkJVk1fUEtUX0RBVEFfSU5CQU5ELCAwKTsKIAotCWRt
LT5zdGF0ZSA9IERNX0lOSVRJQUxJWkVEOworCWRtX2RldmljZS5zdGF0ZSA9IERNX0lOSVRJQUxJ
WkVEOwogfQogCiBzdGF0aWMgdm9pZCBiYWxsb29uX29uY2hhbm5lbGNhbGxiYWNrKHZvaWQgKmNv
bnRleHQpOwpAQCAtMTMxMSw4ICsxMzE0LDggQEAgc3RhdGljIHZvaWQgYmFsbG9vbl9vbmNoYW5u
ZWxjYWxsYmFjayh2b2lkICpjb250ZXh0KQogCiAJCWNhc2UgRE1fVU5CQUxMT09OX1JFUVVFU1Q6
CiAJCQlkbS0+c3RhdGUgPSBETV9CQUxMT09OX0RPV047Ci0JCQliYWxsb29uX2Rvd24oZG0sCi0J
CQkJIChzdHJ1Y3QgZG1fdW5iYWxsb29uX3JlcXVlc3QgKilyZWN2X2J1ZmZlcik7CisJCQlkbS0+
dW5iYWxsb29uX3JlcSA9IChzdHJ1Y3QgZG1fdW5iYWxsb29uX3JlcXVlc3QgKilyZWN2X2J1ZmZl
cjsKKwkJCXNjaGVkdWxlX3dvcmsoJmRtX2RldmljZS51bmJhbGxvb25fd3JrLndyayk7CiAJCQli
cmVhazsKIAogCQljYXNlIERNX01FTV9IT1RfQUREX1JFUVVFU1Q6CkBAIC0xMzg1LDYgKzEzODgs
NyBAQCBzdGF0aWMgaW50IGJhbGxvb25fcHJvYmUoc3RydWN0IGh2X2RldmljZSAqZGV2LAogCWlu
aXRfY29tcGxldGlvbigmZG1fZGV2aWNlLmNvbmZpZ19ldmVudCk7CiAJSU5JVF9MSVNUX0hFQUQo
JmRtX2RldmljZS5oYV9yZWdpb25fbGlzdCk7CiAJSU5JVF9XT1JLKCZkbV9kZXZpY2UuYmFsbG9v
bl93cmsud3JrLCBiYWxsb29uX3VwKTsKKwlJTklUX1dPUksoJmRtX2RldmljZS51bmJhbGxvb25f
d3JrLndyaywgYmFsbG9vbl9kb3duKTsKIAlJTklUX1dPUksoJmRtX2RldmljZS5oYV93cmsud3Jr
LCBob3RfYWRkX3JlcSk7CiAJZG1fZGV2aWNlLmhvc3Rfc3BlY2lmaWVkX2hhX3JlZ2lvbiA9IGZh
bHNlOwogCkBAIC0xNTA4LDYgKzE1MTIsNyBAQCBzdGF0aWMgaW50IGJhbGxvb25fcmVtb3ZlKHN0
cnVjdCBodl9kZXZpY2UgKmRldikKIAkJcHJfd2FybigiQmFsbG9vbmVkIHBhZ2VzOiAlZFxuIiwg
ZG0tPm51bV9wYWdlc19iYWxsb29uZWQpOwogCiAJY2FuY2VsX3dvcmtfc3luYygmZG0tPmJhbGxv
b25fd3JrLndyayk7CisJY2FuY2VsX3dvcmtfc3luYygmZG0tPnVuYmFsbG9vbl93cmsud3JrKTsK
IAljYW5jZWxfd29ya19zeW5jKCZkbS0+aGFfd3JrLndyayk7CiAKIAl2bWJ1c19jbG9zZShkZXYt
PmNoYW5uZWwpOwotLSAKMi4xLjAKCg==

--_002_1db2a50b902f4b5c9f82ebd33c2e4e13BL2PR03MB132namprd03pro_--
