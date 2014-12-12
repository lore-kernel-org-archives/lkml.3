Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbaLLCpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:45:00 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58500 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaLLCo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141211193112.813391696@linutronix.de>
References: <20141211191853.613107396@linutronix.de>
	<20141211193112.813391696@linutronix.de>
Date: Thu, 11 Dec 2014 18:44:58 -0800
X-Google-Sender-Auth: gEulGNRUuMyqs3GeF4ELaf0eTx4
Message-ID: <CAE9FiQV4jArUDGuhb3o2BhiVGcGxSXhADU+5=NsdqJGQOo2oJQ@mail.gmail.com>
Subject: Re: [patch 4/4] acpi: ioapic: Respect the resource flags
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>
Content-Type: multipart/mixed; boundary=001a11c39dc2e767830509fbe0e8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c39dc2e767830509fbe0e8
Content-Type: text/plain; charset=UTF-8

On Thu, Dec 11, 2014 at 11:48 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The acpi parser can set the DISABLED flag on a resource. In
> setup_res() we clear all flags except MEM, so we ignore the DISABLED
> flag. Add proper checks and preserve the flags.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/acpi/ioapic.c |   38 +++++++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 17 deletions(-)
>
> Index: tip/drivers/acpi/ioapic.c
> ===================================================================
> --- tip.orig/drivers/acpi/ioapic.c
> +++ tip/drivers/acpi/ioapic.c
> @@ -40,29 +40,33 @@ struct acpi_pci_ioapic {
>  static LIST_HEAD(ioapic_list);
>  static DEFINE_MUTEX(ioapic_list_lock);
>
> +static inline bool is_valid_mem_resource(struct resource *res)
> +{
> +       return !(res->flags & IORESOURCE_DISABLED) &&
> +               (res->flags & IORESOURCE_MEM);
> +}
> +
>  static acpi_status setup_res(struct acpi_resource *acpi_res, void *data)
>  {
> +       struct acpi_resource_address64 addr;
>         struct resource *res = data;
>
>         memset(res, 0, sizeof(*res));
> -       if (acpi_dev_resource_memory(acpi_res, res)) {
> -               res->flags &= IORESOURCE_MEM;
> -               if (res->flags)
> -                       return AE_OK;
> -       } else if (acpi_dev_resource_address_space(acpi_res, res)) {
> -               struct acpi_resource_address64 addr;
> +       if (acpi_dev_resource_memory(acpi_res, res))
> +               return AE_OK;
>
> -               res->flags &= IORESOURCE_MEM;
> -               if (res->flags &&
> -                   ACPI_SUCCESS(acpi_resource_to_address64(acpi_res, &addr)) &&
> -                   addr.info.mem.caching != ACPI_PREFETCHABLE_MEMORY) {
> -                       res->start += addr.translation_offset;
> -                       res->end += addr.translation_offset;
> -                       return AE_OK;
> -               }
> +       if (!acpi_dev_resource_address_space(acpi_res, res) ||
> +           !is_valid_mem_resource(res))
> +               return AE_OK;
> +       /*
> +        * FIXME: This lacks a proper comment, why the resource
> +        * address needs to be translated.
> +        */
> +       if (ACPI_SUCCESS(acpi_resource_to_address64(acpi_res, &addr)) &&
> +           addr.info.mem.caching != ACPI_PREFETCHABLE_MEMORY) {
> +               res->start += addr.translation_offset;
> +               res->end += addr.translation_offset;
>         }
> -       res->flags = 0;
> -
>         return AE_OK;
>  }
>
> @@ -150,7 +154,7 @@ static acpi_status handle_ioapic_add(acp
>
>                 res = &ioapic->res;
>                 acpi_walk_resources(handle, METHOD_NAME__CRS, setup_res, res);
> -               if (res->flags == IORESOURCE_UNSET) {
> +               if (!is_valid_mem_resource(res)) {
>                         acpi_handle_warn(handle, "failed to get resource\n");
>                         goto exit_free;
>                 } else if (request_resource(&iomem_resource, res)) {
>
>

There is minor problem about mem pref handling, original code will ignore them.

with this patch will let it follow through.

should change is_valid_mem_resource to is_valid_mem_nonpref_resource()...

+static inline bool is_valid_mem_nonpref_resource(struct resource *res)
 {
        return !(res->flags & IORESOURCE_DISABLED) &&
-               (res->flags & IORESOURCE_MEM);
+               (res->flags & IORESOURCE_MEM) &&
+               !(res->flags & IORESOURCE_PREFETCH);
 }


other than that for whole patch set:
Acked-by: Yinghai Lu <yinghai@kernel.org>

Also please check attached following patch that will move code to acpi core.

Thanks

Yinghai

--001a11c39dc2e767830509fbe0e8
Content-Type: text/x-patch; charset=US-ASCII; name="x86_pci_acpi_5.patch"
Content-Disposition: attachment; filename="x86_pci_acpi_5.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3kybex70

U3ViamVjdDogW1BBVENIXSB4ODYsIFBDSSwgQUNQSTogb2Zmc2V0IHJlc291cmNlIGluIGFjcGkg
Y29yZQoKQWxzbyBwYXNzIGJhY2sgdmlhIG9mZnNldCBmb3IgcGNpIHJvb3QgYnVzIHJlc291cmNl
IHByb2JpbmcuCgphbmQgc2V0IElPUkVTT1VSQ0VfUFJFRkVUQ0guLi4KClNpZ25lZC1vZmYtYnk6
IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogYXJjaC94ODYvcGNpL2FjcGku
YyAgICAgICAgICAgIHwgICAyOSArKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVy
cy9hY3BpL2lvYXBpYy5jICAgICAgICAgIHwgICAyMiArKysrKystLS0tLS0tLS0tLS0tLS0tCiBk
cml2ZXJzL2FjcGkvcmVzb3VyY2UuYyAgICAgICAgfCAgIDE2ICsrKysrKysrKysrLS0tLS0KIGRy
aXZlcnMvcG5wL3BucGFjcGkvcnNwYXJzZXIuYyB8ICAgIDIgKy0KIGluY2x1ZGUvbGludXgvYWNw
aS5oICAgICAgICAgICB8ICAgIDIgKy0KIDUgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygr
KSwgNDYgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L3BjaS9hY3BpLmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvcGNpL2FjcGkuYworKysgbGlu
dXgtMi42L2FyY2gveDg2L3BjaS9hY3BpLmMKQEAgLTIzMSw3ICsyMzEsNyBAQCBzdGF0aWMgYWNw
aV9zdGF0dXMgY291bnRfcmVzb3VyY2Uoc3RydWN0CiAKIAltZW1zZXQoJnIsIDAsIHNpemVvZihy
KSk7CiAJaWYgKCFhY3BpX2Rldl9yZXNvdXJjZV9tZW1vcnkoYWNwaV9yZXMsICZyKSAmJgotCSAg
ICAhYWNwaV9kZXZfcmVzb3VyY2VfYWRkcmVzc19zcGFjZShhY3BpX3JlcywgJnIpKQorCSAgICAh
YWNwaV9kZXZfcmVzb3VyY2VfYWRkcmVzc19zcGFjZShhY3BpX3JlcywgJnIsIE5VTEwpKQogCQly
ZXR1cm4gQUVfT0s7CiAKIAlpZiAoaXNfdmFsaWRfcmVzb3VyY2UoJnIpKQpAQCAtMjczLDMwICsy
NzMsMTMgQEAgc3RhdGljIGJvb2wgdmFsaWRfcmVzb3VyY2VfcmFuZ2Uoc3RydWN0CiBzdGF0aWMg
YWNwaV9zdGF0dXMgc2V0dXBfcmVzb3VyY2Uoc3RydWN0IGFjcGlfcmVzb3VyY2UgKmFjcGlfcmVz
LCB2b2lkICpkYXRhKQogewogCXN0cnVjdCBwY2lfcm9vdF9pbmZvICppbmZvID0gZGF0YTsKLQl1
NjQgdHJhbnNsYXRpb25fb2Zmc2V0ID0gMDsKKwl1NjQgb2Zmc2V0ID0gMDsKIAlzdHJ1Y3QgcmVz
b3VyY2UgcjsKIAogCW1lbXNldCgmciwgMCwgc2l6ZW9mKHIpKTsKLQlpZiAoIWFjcGlfZGV2X3Jl
c291cmNlX21lbW9yeShhY3BpX3JlcywgJnIpKSB7Ci0JCXN0cnVjdCBhY3BpX3Jlc291cmNlX2Fk
ZHJlc3M2NCBhZGRyOwotCi0JCWlmICghYWNwaV9kZXZfcmVzb3VyY2VfYWRkcmVzc19zcGFjZShh
Y3BpX3JlcywgJnIpKQotCQkJcmV0dXJuIEFFX09LOwotCi0JCWlmIChBQ1BJX0ZBSUxVUkUoYWNw
aV9yZXNvdXJjZV90b19hZGRyZXNzNjQoYWNwaV9yZXMsICZhZGRyKSkpCi0JCQlyZXR1cm4gQUVf
T0s7Ci0KLQkJaWYgKCFhZGRyLmFkZHJlc3NfbGVuZ3RoKQotCQkJcmV0dXJuIEFFX09LOwotCi0J
CWlmIChhZGRyLnJlc291cmNlX3R5cGUgPT0gQUNQSV9NRU1PUllfUkFOR0UgJiYKLQkJICAgIGFk
ZHIuaW5mby5tZW0uY2FjaGluZyA9PSBBQ1BJX1BSRUZFVENIQUJMRV9NRU1PUlkpCi0JCQlyLmZs
YWdzIHw9IElPUkVTT1VSQ0VfUFJFRkVUQ0g7Ci0KLQkJdHJhbnNsYXRpb25fb2Zmc2V0ID0gYWRk
ci50cmFuc2xhdGlvbl9vZmZzZXQ7Ci0JCXIuc3RhcnQgKz0gdHJhbnNsYXRpb25fb2Zmc2V0Owot
CQlyLmVuZCArPSB0cmFuc2xhdGlvbl9vZmZzZXQ7Ci0JfQorCWlmICghYWNwaV9kZXZfcmVzb3Vy
Y2VfbWVtb3J5KGFjcGlfcmVzLCAmcikgJiYKKwkgICAgIWFjcGlfZGV2X3Jlc291cmNlX2FkZHJl
c3Nfc3BhY2UoYWNwaV9yZXMsICZyLCAmb2Zmc2V0KSkKKwkJcmV0dXJuIEFFX09LOwogCiAJaWYg
KCFpc192YWxpZF9yZXNvdXJjZSgmcikgfHwKIAkgICAgIXZhbGlkX3Jlc291cmNlX3JhbmdlKCZy
LCAmaW5mby0+YnJpZGdlLT5kZXYpKQpAQCAtMzA0LDcgKzI4Nyw3IEBAIHN0YXRpYyBhY3BpX3N0
YXR1cyBzZXR1cF9yZXNvdXJjZShzdHJ1Y3QKIAogCXIubmFtZSA9IGluZm8tPm5hbWU7CiAJaW5m
by0+cmVzW2luZm8tPnJlc19udW1dID0gcjsKLQlpbmZvLT5yZXNfb2Zmc2V0W2luZm8tPnJlc19u
dW1dID0gdHJhbnNsYXRpb25fb2Zmc2V0OworCWluZm8tPnJlc19vZmZzZXRbaW5mby0+cmVzX251
bV0gPSBvZmZzZXQ7CiAJaW5mby0+cmVzX251bSsrOwogCWlmICghcGNpX3VzZV9jcnMpCiAJCWRl
dl9wcmludGsoS0VSTl9ERUJVRywgJmluZm8tPmJyaWRnZS0+ZGV2LApJbmRleDogbGludXgtMi42
L2RyaXZlcnMvYWNwaS9pb2FwaWMuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2
ZXJzL2FjcGkvaW9hcGljLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvaW9hcGljLmMKQEAg
LTQwLDMzICs0MCwyMyBAQCBzdHJ1Y3QgYWNwaV9wY2lfaW9hcGljIHsKIHN0YXRpYyBMSVNUX0hF
QUQoaW9hcGljX2xpc3QpOwogc3RhdGljIERFRklORV9NVVRFWChpb2FwaWNfbGlzdF9sb2NrKTsK
IAotc3RhdGljIGlubGluZSBib29sIGlzX3ZhbGlkX21lbV9yZXNvdXJjZShzdHJ1Y3QgcmVzb3Vy
Y2UgKnJlcykKK3N0YXRpYyBpbmxpbmUgYm9vbCBpc192YWxpZF9tZW1fbm9ucHJlZl9yZXNvdXJj
ZShzdHJ1Y3QgcmVzb3VyY2UgKnJlcykKIHsKIAlyZXR1cm4gIShyZXMtPmZsYWdzICYgSU9SRVNP
VVJDRV9ESVNBQkxFRCkgJiYKLQkJKHJlcy0+ZmxhZ3MgJiBJT1JFU09VUkNFX01FTSk7CisJCShy
ZXMtPmZsYWdzICYgSU9SRVNPVVJDRV9NRU0pICYmCisJCSEocmVzLT5mbGFncyAmIElPUkVTT1VS
Q0VfUFJFRkVUQ0gpOwogfQogCiBzdGF0aWMgYWNwaV9zdGF0dXMgc2V0dXBfcmVzKHN0cnVjdCBh
Y3BpX3Jlc291cmNlICphY3BpX3Jlcywgdm9pZCAqZGF0YSkKIHsKLQlzdHJ1Y3QgYWNwaV9yZXNv
dXJjZV9hZGRyZXNzNjQgYWRkcjsKIAlzdHJ1Y3QgcmVzb3VyY2UgKnJlcyA9IGRhdGE7CiAKIAlt
ZW1zZXQocmVzLCAwLCBzaXplb2YoKnJlcykpOwogCWlmIChhY3BpX2Rldl9yZXNvdXJjZV9tZW1v
cnkoYWNwaV9yZXMsIHJlcykpCiAJCXJldHVybiBBRV9PSzsKIAotCWlmICghYWNwaV9kZXZfcmVz
b3VyY2VfYWRkcmVzc19zcGFjZShhY3BpX3JlcywgcmVzKSB8fAotCSAgICAhaXNfdmFsaWRfbWVt
X3Jlc291cmNlKHJlcykpCi0JCXJldHVybiBBRV9PSzsKLQkvKgotCSAqIEZJWE1FOiBUaGlzIGxh
Y2tzIGEgcHJvcGVyIGNvbW1lbnQsIHdoeSB0aGUgcmVzb3VyY2UKLQkgKiBhZGRyZXNzIG5lZWRz
IHRvIGJlIHRyYW5zbGF0ZWQuCi0JICovCi0JaWYgKEFDUElfU1VDQ0VTUyhhY3BpX3Jlc291cmNl
X3RvX2FkZHJlc3M2NChhY3BpX3JlcywgJmFkZHIpKSAmJgotCSAgICBhZGRyLmluZm8ubWVtLmNh
Y2hpbmcgIT0gQUNQSV9QUkVGRVRDSEFCTEVfTUVNT1JZKSB7Ci0JCXJlcy0+c3RhcnQgKz0gYWRk
ci50cmFuc2xhdGlvbl9vZmZzZXQ7Ci0JCXJlcy0+ZW5kICs9IGFkZHIudHJhbnNsYXRpb25fb2Zm
c2V0OwotCX0KKwlhY3BpX2Rldl9yZXNvdXJjZV9hZGRyZXNzX3NwYWNlKGFjcGlfcmVzLCByZXMs
IE5VTEwpOworCiAJcmV0dXJuIEFFX09LOwogfQogCkBAIC0xNTQsNyArMTQ0LDcgQEAgc3RhdGlj
IGFjcGlfc3RhdHVzIGhhbmRsZV9pb2FwaWNfYWRkKGFjcAogCiAJCXJlcyA9ICZpb2FwaWMtPnJl
czsKIAkJYWNwaV93YWxrX3Jlc291cmNlcyhoYW5kbGUsIE1FVEhPRF9OQU1FX19DUlMsIHNldHVw
X3JlcywgcmVzKTsKLQkJaWYgKCFpc192YWxpZF9tZW1fcmVzb3VyY2UocmVzKSkgeworCQlpZiAo
IWlzX3ZhbGlkX21lbV9ub25wcmVmX3Jlc291cmNlKHJlcykpIHsKIAkJCWFjcGlfaGFuZGxlX3dh
cm4oaGFuZGxlLCAiZmFpbGVkIHRvIGdldCByZXNvdXJjZVxuIik7CiAJCQlnb3RvIGV4aXRfZnJl
ZTsKIAkJfSBlbHNlIGlmIChyZXF1ZXN0X3Jlc291cmNlKCZpb21lbV9yZXNvdXJjZSwgcmVzKSkg
ewpJbmRleDogbGludXgtMi42L2RyaXZlcnMvYWNwaS9yZXNvdXJjZS5jCj09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0t
IGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvYWNwaS9yZXNvdXJjZS5jCisrKyBsaW51eC0yLjYvZHJp
dmVycy9hY3BpL3Jlc291cmNlLmMKQEAgLTE3NSwxMyArMTc1LDE0IEBAIEVYUE9SVF9TWU1CT0xf
R1BMKGFjcGlfZGV2X3Jlc291cmNlX2lvKTsKICAqIGFjcGlfZGV2X3Jlc291cmNlX2FkZHJlc3Nf
c3BhY2UgLSBFeHRyYWN0IEFDUEkgYWRkcmVzcyBzcGFjZSBpbmZvcm1hdGlvbi4KICAqIEBhcmVz
OiBJbnB1dCBBQ1BJIHJlc291cmNlIG9iamVjdC4KICAqIEByZXM6IE91dHB1dCBnZW5lcmljIHJl
c291cmNlIG9iamVjdC4KKyAqIEBvZmZzZXQ6IE91dHB1dCBmb3IgdHJhbnNsYXRpb25fb2Zmc2V0
LgogICoKICAqIENoZWNrIGlmIHRoZSBnaXZlbiBBQ1BJIHJlc291cmNlIG9iamVjdCByZXByZXNl
bnRzIGFuIGFkZHJlc3Mgc3BhY2UgcmVzb3VyY2UKICAqIGFuZCBpZiB0aGF0J3MgdGhlIGNhc2Us
IHVzZSB0aGUgaW5mb3JtYXRpb24gaW4gaXQgdG8gcG9wdWxhdGUgdGhlIGdlbmVyaWMKICAqIHJl
c291cmNlIG9iamVjdCBwb2ludGVkIHRvIGJ5IEByZXMuCiAgKi8KIGJvb2wgYWNwaV9kZXZfcmVz
b3VyY2VfYWRkcmVzc19zcGFjZShzdHJ1Y3QgYWNwaV9yZXNvdXJjZSAqYXJlcywKLQkJCQkgICAg
IHN0cnVjdCByZXNvdXJjZSAqcmVzKQorCQkJCSAgICAgc3RydWN0IHJlc291cmNlICpyZXMsIHU2
NCAqb2Zmc2V0KQogewogCWFjcGlfc3RhdHVzIHN0YXR1czsKIAlzdHJ1Y3QgYWNwaV9yZXNvdXJj
ZV9hZGRyZXNzNjQgYWRkcjsKQEAgLTE5OSwxMiArMjAwLDE0IEBAIGJvb2wgYWNwaV9kZXZfcmVz
b3VyY2VfYWRkcmVzc19zcGFjZShzdHIKIAl9CiAKIAlzdGF0dXMgPSBhY3BpX3Jlc291cmNlX3Rv
X2FkZHJlc3M2NChhcmVzLCAmYWRkcik7Ci0JaWYgKEFDUElfRkFJTFVSRShzdGF0dXMpKQorCWlm
IChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSB8fCAhYWRkci5hZGRyZXNzX2xlbmd0aCkKIAkJcmV0dXJu
IGZhbHNlOwogCi0JcmVzLT5zdGFydCA9IGFkZHIubWluaW11bTsKLQlyZXMtPmVuZCA9IGFkZHIu
bWF4aW11bTsKKwlyZXMtPnN0YXJ0ID0gYWRkci5taW5pbXVtICsgYWRkci50cmFuc2xhdGlvbl9v
ZmZzZXQ7CisJcmVzLT5lbmQgPSBhZGRyLm1heGltdW0gKyBhZGRyLnRyYW5zbGF0aW9uX29mZnNl
dDsKIAl3aW5kb3cgPSBhZGRyLnByb2R1Y2VyX2NvbnN1bWVyID09IEFDUElfUFJPRFVDRVI7CisJ
aWYgKG9mZnNldCkKKwkJKm9mZnNldCA9IGFkZHIudHJhbnNsYXRpb25fb2Zmc2V0OwogCiAJc3dp
dGNoKGFkZHIucmVzb3VyY2VfdHlwZSkgewogCWNhc2UgQUNQSV9NRU1PUllfUkFOR0U6CkBAIC0y
MTIsNiArMjE1LDkgQEAgYm9vbCBhY3BpX2Rldl9yZXNvdXJjZV9hZGRyZXNzX3NwYWNlKHN0cgog
CQlyZXMtPmZsYWdzID0gYWNwaV9kZXZfbWVtcmVzb3VyY2VfZmxhZ3MobGVuLAogCQkJCQkJYWRk
ci5pbmZvLm1lbS53cml0ZV9wcm90ZWN0LAogCQkJCQkJd2luZG93KTsKKwkJaWYgKGFkZHIuaW5m
by5tZW0uY2FjaGluZyA9PSBBQ1BJX1BSRUZFVENIQUJMRV9NRU1PUlkpCisJCQlyZXMtPmZsYWdz
IHw9IElPUkVTT1VSQ0VfUFJFRkVUQ0g7CisKIAkJYnJlYWs7CiAJY2FzZSBBQ1BJX0lPX1JBTkdF
OgogCQlpb19kZWNvZGUgPSBhZGRyLmdyYW51bGFyaXR5ID09IDB4ZmZmID8KQEAgLTQ3MSw3ICs0
NzcsNyBAQCBzdGF0aWMgYWNwaV9zdGF0dXMgYWNwaV9kZXZfcHJvY2Vzc19yZXNvCiAKIAlpZiAo
YWNwaV9kZXZfcmVzb3VyY2VfbWVtb3J5KGFyZXMsICZyKQogCSAgICB8fCBhY3BpX2Rldl9yZXNv
dXJjZV9pbyhhcmVzLCAmcikKLQkgICAgfHwgYWNwaV9kZXZfcmVzb3VyY2VfYWRkcmVzc19zcGFj
ZShhcmVzLCAmcikKKwkgICAgfHwgYWNwaV9kZXZfcmVzb3VyY2VfYWRkcmVzc19zcGFjZShhcmVz
LCAmciwgTlVMTCkKIAkgICAgfHwgYWNwaV9kZXZfcmVzb3VyY2VfZXh0X2FkZHJlc3Nfc3BhY2Uo
YXJlcywgJnIpKQogCQlyZXR1cm4gYWNwaV9kZXZfbmV3X3Jlc291cmNlX2VudHJ5KCZyLCBjKTsK
IApJbmRleDogbGludXgtMi42L2RyaXZlcnMvcG5wL3BucGFjcGkvcnNwYXJzZXIuYwo9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL3BucC9wbnBhY3BpL3JzcGFyc2VyLmMKKysr
IGxpbnV4LTIuNi9kcml2ZXJzL3BucC9wbnBhY3BpL3JzcGFyc2VyLmMKQEAgLTE4Myw3ICsxODMs
NyBAQCBzdGF0aWMgYWNwaV9zdGF0dXMgcG5wYWNwaV9hbGxvY2F0ZWRfcmVzCiAJc3RydWN0IHJl
c291cmNlIHIgPSB7MH07CiAJaW50IGksIGZsYWdzOwogCi0JaWYgKGFjcGlfZGV2X3Jlc291cmNl
X2FkZHJlc3Nfc3BhY2UocmVzLCAmcikKKwlpZiAoYWNwaV9kZXZfcmVzb3VyY2VfYWRkcmVzc19z
cGFjZShyZXMsICZyLCBOVUxMKQogCSAgICB8fCBhY3BpX2Rldl9yZXNvdXJjZV9leHRfYWRkcmVz
c19zcGFjZShyZXMsICZyKSkgewogCQlwbnBfYWRkX3Jlc291cmNlKGRldiwgJnIpOwogCQlyZXR1
cm4gQUVfT0s7CkluZGV4OiBsaW51eC0yLjYvaW5jbHVkZS9saW51eC9hY3BpLmgKPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQotLS0gbGludXgtMi42Lm9yaWcvaW5jbHVkZS9saW51eC9hY3BpLmgKKysrIGxpbnV4LTIuNi9p
bmNsdWRlL2xpbnV4L2FjcGkuaApAQCAtMjkyLDcgKzI5Miw3IEBAIGV4dGVybiBpbnQgcG5wYWNw
aV9kaXNhYmxlZDsKIGJvb2wgYWNwaV9kZXZfcmVzb3VyY2VfbWVtb3J5KHN0cnVjdCBhY3BpX3Jl
c291cmNlICphcmVzLCBzdHJ1Y3QgcmVzb3VyY2UgKnJlcyk7CiBib29sIGFjcGlfZGV2X3Jlc291
cmNlX2lvKHN0cnVjdCBhY3BpX3Jlc291cmNlICphcmVzLCBzdHJ1Y3QgcmVzb3VyY2UgKnJlcyk7
CiBib29sIGFjcGlfZGV2X3Jlc291cmNlX2FkZHJlc3Nfc3BhY2Uoc3RydWN0IGFjcGlfcmVzb3Vy
Y2UgKmFyZXMsCi0JCQkJICAgICBzdHJ1Y3QgcmVzb3VyY2UgKnJlcyk7CisJCQkJICAgICBzdHJ1
Y3QgcmVzb3VyY2UgKnJlcywgdTY0ICpvZmZzZXQpOwogYm9vbCBhY3BpX2Rldl9yZXNvdXJjZV9l
eHRfYWRkcmVzc19zcGFjZShzdHJ1Y3QgYWNwaV9yZXNvdXJjZSAqYXJlcywKIAkJCQkJIHN0cnVj
dCByZXNvdXJjZSAqcmVzKTsKIHVuc2lnbmVkIGxvbmcgYWNwaV9kZXZfaXJxX2ZsYWdzKHU4IHRy
aWdnZXJpbmcsIHU4IHBvbGFyaXR5LCB1OCBzaGFyZWFibGUpOwo=
--001a11c39dc2e767830509fbe0e8--
