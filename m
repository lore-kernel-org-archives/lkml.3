Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3IYOfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:35:47 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:65247 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab3IYOfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <1380105868-31985-3-git-send-email-liuj97@gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
	<1380105868-31985-3-git-send-email-liuj97@gmail.com>
Date: Wed, 25 Sep 2013 20:05:43 +0530
Message-ID: <CA+b37P2McAMq80jppqoD58QjhrJ7f2cEX4JJdivVfuRH1-69VQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/7] arm64: introduce interfaces to hotpatch kernel and
 module code
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b5d64f210b0f904e7362bfc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b5d64f210b0f904e7362bfc
Content-Type: text/plain; charset=ISO-8859-1

On 25 September 2013 16:14, Jiang Liu <liuj97@gmail.com> wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
>
> Introduce aarch64_insn_patch_text() and __aarch64_insn_patch_text()
> to patch kernel and module code.
>
> Function aarch64_insn_patch_text() is a heavy version which may use
> stop_machine() to serialize all online CPUs, and function
> __aarch64_insn_patch_text() is light version without explicitly
> serialization.
Hi Jiang,

I have written kprobes support for aarch64, and need both the
functionality (lightweight and stop_machine() versions).
I would like to rebase these API in kprobes, however slight changes
would require in case of stop_machine version, which I explained
below.
[Though kprobes cannot share Instruction encode support of jump labels
as, decoding & simulation quite different for kprobes/uprobes and
based around single stepping]

>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/include/asm/insn.h |  2 ++
>  arch/arm64/kernel/insn.c      | 64 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
>
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> index e7d1bc8..0ea7193 100644
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -49,5 +49,7 @@ __AARCH64_INSN_FUNCS(nop,     0xFFFFFFFF, 0xD503201F)
>  enum aarch64_insn_class aarch64_get_insn_class(u32 insn);
>
>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
> +int aarch64_insn_patch_text(void *addr, u32 *insns, int cnt);
> +int __aarch64_insn_patch_text(void *addr, u32 *insns, int cnt);
>
>  #endif /* _ASM_ARM64_INSN_H */
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 8541c3a..50facfc 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -15,6 +15,8 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  #include <linux/kernel.h>
> +#include <linux/stop_machine.h>
> +#include <asm/cacheflush.h>
>  #include <asm/insn.h>
>
>  static int aarch64_insn_cls[] = {
> @@ -69,3 +71,65 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
>         return __aarch64_insn_hotpatch_safe(old_insn) &&
>                __aarch64_insn_hotpatch_safe(new_insn);
>  }
> +
> +struct aarch64_insn_patch {
> +       void    *text_addr;
> +       u32     *new_insns;
> +       int     insn_cnt;
> +};
> +
> +int __kprobes __aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
> +{
> +       int i;
> +       u32 *tp = addr;
> +
> +       /* instructions must be word aligned */
> +       if (cnt <= 0 || ((uintptr_t)addr & 0x3))
> +               return -EINVAL;
> +
> +       for (i = 0; i < cnt; i++)
> +               tp[i] = insns[i];
> +
> +       flush_icache_range((uintptr_t)tp, (uintptr_t)tp + cnt * sizeof(u32));
> +
> +       return 0;
> +}
Looks fine, but do you need to check for CPU big endian mode here? (I
think swab32() needed if EL1 is in big-endian mode)

> +
> +static int __kprobes aarch64_insn_patch_text_cb(void *arg)
> +{
> +       struct aarch64_insn_patch *pp = arg;
> +
> +       return __aarch64_insn_patch_text(pp->text_addr, pp->new_insns,
> +                                        pp->insn_cnt);
> +}
> +
> +int __kprobes aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
> +{
> +       int ret;
> +       bool safe = false;
> +
> +       /* instructions must be word aligned */
> +       if (cnt <= 0 || ((uintptr_t)addr & 0x3))
> +               return -EINVAL;
> +
> +       if (cnt == 1)
> +               safe = aarch64_insn_hotpatch_safe(*(u32 *)addr, insns[0]);
> +
> +       if (safe) {
> +               ret = __aarch64_insn_patch_text(addr, insns, cnt);
> +       } else {

Can you move the code below this into separate API that just apply
patch with stop_machine? And then a wrapper function for jump label
specific handling that checks for aarch64_insn_hotpatch_safe() ?
Also, it will be good to move the patching code out of insn.c to
patch.c (refer to arch/arm/kernel/patch.c).

Please refer to attached file (my current implementation) to make
sense of exactly what kprobes would need (ignore the big-endian part
for now). I think splitting the code should be straight-forward and we
can avoid two different implementations. Please let me know if this
can be done, I will rebase my patches above your next version.

Thanks,
Sandeepa
> +               struct aarch64_insn_patch patch = {
> +                       .text_addr = addr,
> +                       .new_insns = insns,
> +                       .insn_cnt = cnt,
> +               };
> +
> +               /*
> +                * Execute __aarch64_insn_patch_text() on every online CPU,
> +                * which ensure serialization among all online CPUs.
> +                */
> +               ret = stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
> +       }
> +
> +       return ret;
> +}
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--047d7b5d64f210b0f904e7362bfc
Content-Type: text/x-csrc; charset=US-ASCII; name="patch_text.c"
Content-Disposition: attachment; filename="patch_text.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm0nlr4z0

LyoKICogYXJjaC9hcm02NC9rZXJuZWwvcGF0Y2hfdGV4dC5jCiAqCiAqIENvcHlyaWdodCAoQykg
MjAxMyBMaW5hcm8gTGltaXRlZC4KICogQmFzZWQgb24gYXJjaC9hcm0va2VybmVsL3BhdGNoLmMK
ICoKICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRl
IGl0IGFuZC9vciBtb2RpZnkKICogaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJh
bCBQdWJsaWMgTGljZW5zZSB2ZXJzaW9uIDIgYXMKICogcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNv
ZnR3YXJlIEZvdW5kYXRpb24uCiAqCiAqIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0
aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAogKiBidXQgV0lUSE9VVCBBTlkgV0FSUkFO
VFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgogKiBNRVJDSEFOVEFCSUxJ
VFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlIEdOVQogKiBH
ZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCiAqLwojaW5jbHVkZSA8bGlu
dXgva2VybmVsLmg+CiNpbmNsdWRlIDxsaW51eC9rcHJvYmVzLmg+CiNpbmNsdWRlIDxsaW51eC9z
dG9wX21hY2hpbmUuaD4KI2luY2x1ZGUgPGxpbnV4L3N3YWIuaD4KI2luY2x1ZGUgPGFzbS9jYWNo
ZWZsdXNoLmg+CiNpbmNsdWRlIDxhc20vc21wX3BsYXQuaD4KCiNpbmNsdWRlICJwYXRjaF90ZXh0
LmgiCgojZGVmaW5lIG9wY29kZV90b19tZW1fbGUoeCkgKHgpCiNkZWZpbmUgb3Bjb2RlX3RvX21l
bV9iZSh4KSBzd2FiMzIoeCkKCi8qCiAqIGdldCBjcHUgZW5kaWFuIG1vZGUgZnJvbSBTQ1RMUl9F
TDEuRUUKICogMHgxPUJpZyBFbmRpYW4sIDB4MD1MaXRsZSBFbmRpYW4uCiAqLwpzdGF0aWMgaW5s
aW5lIHVuc2lnbmVkIGludCBpc19lbDFfYmlnX2VuZGlhbih2b2lkKQp7Cgl1MzIgc2N0bHI7CgoJ
YXNtIHZvbGF0aWxlICgibXJzICUwLCBzY3Rscl9lbDEiIDogIj1yIiAoc2N0bHIpKTsKCXJldHVy
biAoc2N0bHIgPj4gMjUpICYgMHgxOwp9CgpzdHJ1Y3QgcGF0Y2ggewoJdm9pZCAqYWRkcjsKCXVu
c2lnbmVkIGludCBpbnNuOwp9OwoKLyogUGF0Y2ggdGV4dCAtIFN1cHBvcnRlZCBmb3Iga2VybmVs
IGluIEFBcmNoNjQgbW9kZSBvbmx5ICovCnZvaWQgX19rcHJvYmVzIF9fcGF0Y2hfdGV4dCh2b2lk
ICphZGRyLCB1bnNpZ25lZCBpbnQgaW5zbikKewoJaW50IHNpemUgPSBzaXplb2YodTMyKTsKCgkv
KiBhZGRyZXNzIDMyLWJpdCBhbGlnbm1lbnQgY2hlY2sgKi8KCWlmICgodW5zaWduZWQgbG9uZylh
ZGRyICUgc2l6ZSkgewoJCXByX3dhcm4oInRleHQgcGF0Y2hpbmcgZmFpbGVkIEB1bmFsaWduZWQg
YWRkciAlcFxuIiwgYWRkcik7CgkJcmV0dXJuOwoJfQoKCWlmIChpc19lbDFfYmlnX2VuZGlhbigp
KQoJCSoodTMyICopIGFkZHIgPSBvcGNvZGVfdG9fbWVtX2JlKGluc24pOwoJZWxzZQoJCSoodTMy
ICopIGFkZHIgPSBvcGNvZGVfdG9fbWVtX2xlKGluc24pOwoKCS8qIHN5bmMgSWNhY2hlLCBJU0Ig
aXMgaXNzdWVkIGFzIHBhcnQgb2YgdGhpcyAqLwoJZmx1c2hfaWNhY2hlX3JhbmdlKCh1aW50cHRy
X3QpIChhZGRyKSwgKHVpbnRwdHJfdCkgKGFkZHIpICsgc2l6ZSk7Cn0KCnN0YXRpYyBpbnQgX19r
cHJvYmVzIHBhdGNoX3RleHRfc3RvcF9tYWNoaW5lKHZvaWQgKmRhdGEpCnsKCXN0cnVjdCBwYXRj
aCAqcGF0Y2ggPSBkYXRhOwoKCV9fcGF0Y2hfdGV4dChwYXRjaC0+YWRkciwgcGF0Y2gtPmluc24p
OwoJcmV0dXJuIDA7Cn0KCnZvaWQgX19rcHJvYmVzIHBhdGNoX3RleHQodm9pZCAqYWRkciwgdW5z
aWduZWQgaW50IGluc24pCnsKCXN0cnVjdCBwYXRjaCBwYXRjaCA9IHsKCQkuYWRkciA9IGFkZHIs
CgkJLmluc24gPSBpbnNuLAoJfTsKCXN0b3BfbWFjaGluZShwYXRjaF90ZXh0X3N0b3BfbWFjaGlu
ZSwgJnBhdGNoLCBjcHVfb25saW5lX21hc2spOwp9Cg==
--047d7b5d64f210b0f904e7362bfc--
