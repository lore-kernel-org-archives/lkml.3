Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaLJEIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 23:08:12 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39009 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaLJEIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 23:08:10 -0500
MIME-Version: 1.0
In-Reply-To: <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
	<tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
Date: Tue, 9 Dec 2014 20:08:09 -0800
X-Google-Sender-Auth: CpCibaU9Z0gHMmLpeqzla8JtxIE
Message-ID: <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function
 resource_to_addr() in arch/x86/pci/acpi.c
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0158aa1cb63d850509d4ce6f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0158aa1cb63d850509d4ce6f
Content-Type: text/plain; charset=UTF-8

On Mon, Nov 3, 2014 at 2:57 AM, tip-bot for Jiang Liu <tipbot@zytor.com> wrote:
> Commit-ID:  e22ce93870deae0e9a54e1539f0088538f187780
> Gitweb:     http://git.kernel.org/tip/e22ce93870deae0e9a54e1539f0088538f187780
> Author:     Jiang Liu <jiang.liu@linux.intel.com>
> AuthorDate: Mon, 27 Oct 2014 13:21:34 +0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon, 3 Nov 2014 11:56:07 +0100
>
> x86, PCI, ACPI: Kill private function resource_to_addr() in arch/x86/pci/acpi.c
>
> Private function resource_to_addr() is used to parse ACPI resources
> for PCI host bridge. There are public interfaces available for that
> purpose, so replace resource_to_addr() with public interfaces.
>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Link: http://lkml.kernel.org/r/1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/pci/acpi.c | 144 +++++++++++++++++++---------------------------------
>  1 file changed, 53 insertions(+), 91 deletions(-)
>
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index cfd1b13..3f72d93 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -218,114 +218,76 @@ static void teardown_mcfg_map(struct pci_root_info *info)
>  }
>  #endif
>
> -static acpi_status resource_to_addr(struct acpi_resource *resource,
> -                                   struct acpi_resource_address64 *addr)
> -{
> -       acpi_status status;
> -       struct acpi_resource_memory24 *memory24;
> -       struct acpi_resource_memory32 *memory32;
> -       struct acpi_resource_fixed_memory32 *fixed_memory32;
> -
> -       memset(addr, 0, sizeof(*addr));
> -       switch (resource->type) {
> -       case ACPI_RESOURCE_TYPE_MEMORY24:
> -               memory24 = &resource->data.memory24;
> -               addr->resource_type = ACPI_MEMORY_RANGE;
> -               addr->minimum = memory24->minimum;
> -               addr->address_length = memory24->address_length;
> -               addr->maximum = addr->minimum + addr->address_length - 1;
> -               return AE_OK;
> -       case ACPI_RESOURCE_TYPE_MEMORY32:
> -               memory32 = &resource->data.memory32;
> -               addr->resource_type = ACPI_MEMORY_RANGE;
> -               addr->minimum = memory32->minimum;
> -               addr->address_length = memory32->address_length;
> -               addr->maximum = addr->minimum + addr->address_length - 1;
> -               return AE_OK;
> -       case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> -               fixed_memory32 = &resource->data.fixed_memory32;
> -               addr->resource_type = ACPI_MEMORY_RANGE;
> -               addr->minimum = fixed_memory32->address;
> -               addr->address_length = fixed_memory32->address_length;
> -               addr->maximum = addr->minimum + addr->address_length - 1;
> -               return AE_OK;
> -       case ACPI_RESOURCE_TYPE_ADDRESS16:
> -       case ACPI_RESOURCE_TYPE_ADDRESS32:
> -       case ACPI_RESOURCE_TYPE_ADDRESS64:
> -               status = acpi_resource_to_address64(resource, addr);
> -               if (ACPI_SUCCESS(status) &&
> -                   (addr->resource_type == ACPI_MEMORY_RANGE ||
> -                   addr->resource_type == ACPI_IO_RANGE) &&
> -                   addr->address_length > 0) {
> -                       return AE_OK;
> -               }
> -               break;
> -       }
> -       return AE_ERROR;
> -}
> -
>  static acpi_status count_resource(struct acpi_resource *acpi_res, void *data)
>  {
>         struct pci_root_info *info = data;
> -       struct acpi_resource_address64 addr;
> -       acpi_status status;
> +       struct resource r = {
> +               .flags = 0
> +       };
>
> -       status = resource_to_addr(acpi_res, &addr);
> -       if (ACPI_SUCCESS(status))
> +       if (!acpi_dev_resource_memory(acpi_res, &r) &&
> +           !acpi_dev_resource_address_space(acpi_res, &r))
> +               return AE_OK;
> +
> +       if ((r.flags & (IORESOURCE_IO | IORESOURCE_MEM)) && resource_size(&r))
>                 info->res_num++;
> +
>         return AE_OK;
>  }
>
>  static acpi_status setup_resource(struct acpi_resource *acpi_res, void *data)
>  {
>         struct pci_root_info *info = data;
> -       struct resource *res;
> -       struct acpi_resource_address64 addr;
> -       acpi_status status;
> -       unsigned long flags;
> -       u64 start, orig_end, end;
> +       u64 translation_offset = 0;
> +       struct resource r = {
> +               .flags = 0
> +       };
> +
> +       if (acpi_dev_resource_memory(acpi_res, &r)) {
> +               r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
> +       } else if (acpi_dev_resource_address_space(acpi_res, &r)) {
> +               u64 orig_end;
> +               struct acpi_resource_address64 addr;
> +
> +               r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
> +               if (r.flags == 0)
> +                       return AE_OK;
>
> -       status = resource_to_addr(acpi_res, &addr);
> -       if (!ACPI_SUCCESS(status))
> -               return AE_OK;
> +               if (ACPI_FAILURE(acpi_resource_to_address64(acpi_res, &addr)))
> +                       return AE_OK;
>
> -       if (addr.resource_type == ACPI_MEMORY_RANGE) {
> -               flags = IORESOURCE_MEM;
> -               if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> -                       flags |= IORESOURCE_PREFETCH;
> -       } else if (addr.resource_type == ACPI_IO_RANGE) {
> -               flags = IORESOURCE_IO;
> -       } else
> -               return AE_OK;
> +               if (addr.resource_type == ACPI_MEMORY_RANGE &&
> +                   addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> +                       r.flags |= IORESOURCE_PREFETCH;
>
> -       start = addr.minimum + addr.translation_offset;
> -       orig_end = end = addr.maximum + addr.translation_offset;
> +               translation_offset = addr.translation_offset;
> +               orig_end = r.end;
> +               r.start += translation_offset;
> +               r.end += translation_offset;
>
> -       /* Exclude non-addressable range or non-addressable portion of range */
> -       end = min(end, (u64)iomem_resource.end);
> -       if (end <= start) {
> -               dev_info(&info->bridge->dev,
> -                       "host bridge window [%#llx-%#llx] "
> -                       "(ignored, not CPU addressable)\n", start, orig_end);
> -               return AE_OK;
> -       } else if (orig_end != end) {
> -               dev_info(&info->bridge->dev,
> -                       "host bridge window [%#llx-%#llx] "
> -                       "([%#llx-%#llx] ignored, not CPU addressable)\n",
> -                       start, orig_end, end + 1, orig_end);
> +               /* Exclude non-addressable range or non-addressable portion of range */
> +               r.end = min(r.end, iomem_resource.end);
> +               if (r.end <= r.start) {
> +                       dev_info(&info->bridge->dev,
> +                               "host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
> +                                r.start, orig_end);
> +                       return AE_OK;
> +               } else if (orig_end != r.end) {
> +                       dev_info(&info->bridge->dev,
> +                               "host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
> +                               r.start, orig_end, r.end + 1, orig_end);
> +               }
>         }
>
> -       res = &info->res[info->res_num];
> -       res->name = info->name;
> -       res->flags = flags;
> -       res->start = start;
> -       res->end = end;
> -       info->res_offset[info->res_num] = addr.translation_offset;
> -       info->res_num++;
> -
> -       if (!pci_use_crs)
> -               dev_printk(KERN_DEBUG, &info->bridge->dev,
> -                          "host bridge window %pR (ignored)\n", res);
> +       if (r.flags && resource_size(&r)) {
> +               r.name = info->name;
> +               info->res[info->res_num] = r;
> +               info->res_offset[info->res_num] = translation_offset;
> +               info->res_num++;
> +               if (!pci_use_crs)
> +                       dev_printk(KERN_DEBUG, &info->bridge->dev,
> +                                  "host bridge window %pR (ignored)\n", &r);
> +       }
>
>         return AE_OK;
>  }

This one cause one system with Nehalem and one with Westmere failing.

[   32.353347] acpi PNP0A08:00: host bridge window expanded to [mem
0x00000000-0xffffffff]; [mem 0x000a0000-0x000bffff] ignored
[   32.362897] acpi PNP0A08:00: host bridge window expanded to [mem
0x00000000-0xffffffff]; [mem 0x000d0000-0x000dffff] ignored
[   32.382862] acpi PNP0A08:00: host bridge window expanded to [mem
0x00000000-0xffffffff]; [mem 0x00000000-0xffffffff] ignored
[   32.402889] acpi PNP0A08:00: host bridge window expanded to [mem
0x00000000-0xffffffff]; [??? 0x00000000-0xffffffff flags 0x0] ignored
[   32.423000] acpi PNP0A08:00: host bridge window expanded to [mem
0x00000000-0xffffffff]; [mem 0x00000000-0xffffffff] ignored
[   32.602921] PCI host bridge to bus 0000:00
[   32.603158] pci_bus 0000:00: root bus resource [bus 00-3f]
[   32.622782] pci_bus 0000:00: root bus resource [io  0x0000-0x5fff]
[   32.642569] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[   32.642893] pci_bus 0000:00: root bus resource [mem
0xfc000000000-0xfc07fffffff pref]

Looks like the commit have several problems.

Attached patch should address them.

Please fix it before it get into linus tree.

Thanks

Yinghai

--089e0158aa1cb63d850509d4ce6f
Content-Type: text/x-patch; charset=US-ASCII; name="fix_x86_pci_acpi.patch"
Content-Disposition: attachment; filename="fix_x86_pci_acpi.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3i6a9mc0

U3ViamVjdDogW1BBVENIXSB4ODYsIHBjaSwgYWNwaTogZml4IHJvb3QgcmVzIHByb2JpbmcKCm9s
ZCBzZXR1cCB3aXRoIG5laGFsZW0gZ290OgpbICAgMzIuMzUzMzQ3XSBhY3BpIFBOUDBBMDg6MDA6
IGhvc3QgYnJpZGdlIHdpbmRvdyBleHBhbmRlZCB0byBbbWVtIDB4MDAwMDAwMDAtMHhmZmZmZmZm
Zl07IFttZW0gMHgwMDBhMDAwMC0weDAwMGJmZmZmXSBpZ25vcmVkClsgICAzMi4zNjI4OTddIGFj
cGkgUE5QMEEwODowMDogaG9zdCBicmlkZ2Ugd2luZG93IGV4cGFuZGVkIHRvIFttZW0gMHgwMDAw
MDAwMC0weGZmZmZmZmZmXTsgW21lbSAweDAwMGQwMDAwLTB4MDAwZGZmZmZdIGlnbm9yZWQKWyAg
IDMyLjM4Mjg2Ml0gYWNwaSBQTlAwQTA4OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cgZXhwYW5kZWQg
dG8gW21lbSAweDAwMDAwMDAwLTB4ZmZmZmZmZmZdOyBbbWVtIDB4MDAwMDAwMDAtMHhmZmZmZmZm
Zl0gaWdub3JlZApbICAgMzIuNDAyODg5XSBhY3BpIFBOUDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdp
bmRvdyBleHBhbmRlZCB0byBbbWVtIDB4MDAwMDAwMDAtMHhmZmZmZmZmZl07IFs/Pz8gMHgwMDAw
MDAwMC0weGZmZmZmZmZmIGZsYWdzIDB4MF0gaWdub3JlZApbICAgMzIuNDIzMDAwXSBhY3BpIFBO
UDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBleHBhbmRlZCB0byBbbWVtIDB4MDAwMDAwMDAt
MHhmZmZmZmZmZl07IFttZW0gMHgwMDAwMDAwMC0weGZmZmZmZmZmXSBpZ25vcmVkClsgICAzMi42
MDI5MjFdIFBDSSBob3N0IGJyaWRnZSB0byBidXMgMDAwMDowMApbICAgMzIuNjAzMTU4XSBwY2lf
YnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFtidXMgMDAtM2ZdClsgICAzMi42MjI3ODJd
IHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW2lvICAweDAwMDAtMHg1ZmZmXQpb
ICAgMzIuNjQyNTY5XSBwY2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFttZW0gMHgw
MDAwMDAwMC0weGZmZmZmZmZmXQpbICAgMzIuNjQyODkzXSBwY2lfYnVzIDAwMDA6MDA6IHJvb3Qg
YnVzIHJlc291cmNlIFttZW0gMHhmYzAwMDAwMDAwMC0weGZjMDdmZmZmZmZmIHByZWZdCgpUaGUg
cHJvYmxlbSBpcyBjYXVzZWQgY29tbWl0IGUyMmNlOTM4NzBkZSAoIng4NiwgUENJLCBBQ1BJOiBL
aWxsIHByaXZhdGUgZnVuY3Rpb24gcmVzb3VyY2VfdG9fYWRkcigpIGluIGFyY2gveDg2L3BjaS9h
Y3BpLmMiKS4KCmFzIHRoZSBzeXN0ZW0gaGFzClsgICAzMi4zOTU1MDRdIGFjcGkgUE5QMEEwODow
MDogYWRkciBob3N0IGJyaWRnZSB3aW5kb3cgW2J1cyAwMC0zZl0KWyAgIDMyLjQxMjM5NV0gYWNw
aSBQTlAwQTA4OjAwOiBhZGRyIGhvc3QgYnJpZGdlIHdpbmRvdyBbaW8gIDB4MDAwMC0weDVmZmYg
d2luZG93XQpbICAgMzIuNDEyNzQ1XSBhY3BpIFBOUDBBMDg6MDA6IGFkZHIgaG9zdCBicmlkZ2Ug
d2luZG93IFttZW0gMHgwMDBhMDAwMC0weDAwMGJmZmZmIHdpbmRvd10KWyAgIDMyLjQzMjU1OV0g
YWNwaSBQTlAwQTA4OjAwOiBhZGRyIGhvc3QgYnJpZGdlIHdpbmRvdyBbbWVtIDB4MDAwZDAwMDAt
MHgwMDBkZmZmZiB3aW5kb3ddClsgICAzMi40NTI0MzJdIGFjcGkgUE5QMEEwODowMDogYWRkciBo
b3N0IGJyaWRnZSB3aW5kb3cgW21lbSAweDAwMDAwMDAwLTB4ZmZmZmZmZmYgd2luZG93XQpbICAg
MzIuNDcyMzAzXSBhY3BpIFBOUDBBMDg6MDA6IGFkZHIgaG9zdCBicmlkZ2Ugd2luZG93IFttZW0g
MHg5MDAwMDAwMC0weGFmZmZmZmZmIHdpbmRvd10KWyAgIDMyLjQ3MjY1M10gYWNwaSBQTlAwQTA4
OjAwOiBhZGRyIGhvc3QgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmVkNDAwMDAtMHhmZWQ0NGZmZiB3
aW5kb3ddClsgICAzMi40OTI1MzldIGFjcGkgUE5QMEEwODowMDogYWRkciBob3N0IGJyaWRnZSB3
aW5kb3cgW21lbSAweGZjMDAwMDAwMDAwLTB4ZmMwN2ZmZmZmZmYgd2luZG93XQoKYnV0IHRoZSBv
bmUgW21lbSAweDAwMDAwMDAwLTB4ZmZmZmZmZmYgd2luZG93XSB3aXRoIGFkZHJlc3NfbGVuZ3Ro
ID09IDAgdGhhdCB3YXMKcmVqZWN0ZWQgYnkgb2xkIHJlc291cmNlX3RvX2FkZHIoKS4KCkFkZCB0
aGF0IGNoZWNrIGludG8gYWNwaV9kZXZfcmVzb3VyY2VfYWRkcmVzc19zcGFjZSgpIHRvIGZpeCB0
aGUgcHJvYmxlbS4KCkFsc28gZml4ZXMgb3RoZXIgcHJvYmxlbXM6CjEuIG5lZWQgdG8gaW5pdGlh
bGl6ZSBsb2NhbCByIGFuZCBhZGRyIHRvIDAuCjIuIGZpeCBvcmlnX2VuZCBhc3NpZ25pbmcsIGFz
IGl0IHNob3VsZCBiZSBhZnRlciBvZmZzZXQgYWRkaW5nLgozLiBuZWVkIHRvIGRvIGNsaXBwaW5n
IGFuZCBjaGVja2luZyBmb3IgYWNwaV9kZXZfcmVzb3VyY2VfbWVtb3J5IHBhdGguCjQuIGFsc28g
YWNwaV9kZXZfcmVzb3VyY2VfbWVtb3J5IHNob3VsZCAmIHdpdGggSU9SRVNPVVJDRV9NRU0uCgpG
aXhlczogY29tbWl0IGUyMmNlOTM4NzBkZSAoIng4NiwgUENJLCBBQ1BJOiBLaWxsIHByaXZhdGUg
ZnVuY3Rpb24gcmVzb3VyY2VfdG9fYWRkcigpIGluIGFyY2gveDg2L3BjaS9hY3BpLmMiKS4KU2ln
bmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4
Ni9wY2kvYWNwaS5jICAgICB8ICAgNjAgKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL2FjcGkvcmVzb3VyY2UuYyB8ICAgIDIgLQogMiBmaWxl
cyBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCAzMiBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51
eC0yLjYvYXJjaC94ODYvcGNpL2FjcGkuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9h
cmNoL3g4Ni9wY2kvYWNwaS5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvcGNpL2FjcGkuYwpAQCAt
MjIxLDEwICsyMjEsOSBAQCBzdGF0aWMgdm9pZCB0ZWFyZG93bl9tY2ZnX21hcChzdHJ1Y3QgcGNp
CiBzdGF0aWMgYWNwaV9zdGF0dXMgY291bnRfcmVzb3VyY2Uoc3RydWN0IGFjcGlfcmVzb3VyY2Ug
KmFjcGlfcmVzLCB2b2lkICpkYXRhKQogewogCXN0cnVjdCBwY2lfcm9vdF9pbmZvICppbmZvID0g
ZGF0YTsKLQlzdHJ1Y3QgcmVzb3VyY2UgciA9IHsKLQkJLmZsYWdzID0gMAotCX07CisJc3RydWN0
IHJlc291cmNlIHI7CiAKKwltZW1zZXQoJnIsIDAsIHNpemVvZihyKSk7CiAJaWYgKCFhY3BpX2Rl
dl9yZXNvdXJjZV9tZW1vcnkoYWNwaV9yZXMsICZyKSAmJgogCSAgICAhYWNwaV9kZXZfcmVzb3Vy
Y2VfYWRkcmVzc19zcGFjZShhY3BpX3JlcywgJnIpKQogCQlyZXR1cm4gQUVfT0s7CkBAIC0yMzks
MjAgKzIzOCwyMCBAQCBzdGF0aWMgYWNwaV9zdGF0dXMgc2V0dXBfcmVzb3VyY2Uoc3RydWN0CiB7
CiAJc3RydWN0IHBjaV9yb290X2luZm8gKmluZm8gPSBkYXRhOwogCXU2NCB0cmFuc2xhdGlvbl9v
ZmZzZXQgPSAwOwotCXN0cnVjdCByZXNvdXJjZSByID0gewotCQkuZmxhZ3MgPSAwCi0JfTsKKwlz
dHJ1Y3QgcmVzb3VyY2UgcjsKKwl1NjQgb3JpZ19lbmQ7CiAKKwltZW1zZXQoJnIsIDAsIHNpemVv
ZihyKSk7CiAJaWYgKGFjcGlfZGV2X3Jlc291cmNlX21lbW9yeShhY3BpX3JlcywgJnIpKSB7Ci0J
CXIuZmxhZ3MgJj0gSU9SRVNPVVJDRV9NRU0gfCBJT1JFU09VUkNFX0lPOworCQlyLmZsYWdzICY9
IElPUkVTT1VSQ0VfTUVNOwogCX0gZWxzZSBpZiAoYWNwaV9kZXZfcmVzb3VyY2VfYWRkcmVzc19z
cGFjZShhY3BpX3JlcywgJnIpKSB7Ci0JCXU2NCBvcmlnX2VuZDsKIAkJc3RydWN0IGFjcGlfcmVz
b3VyY2VfYWRkcmVzczY0IGFkZHI7CiAKIAkJci5mbGFncyAmPSBJT1JFU09VUkNFX01FTSB8IElP
UkVTT1VSQ0VfSU87CiAJCWlmIChyLmZsYWdzID09IDApCiAJCQlyZXR1cm4gQUVfT0s7CiAKKwkJ
bWVtc2V0KCZhZGRyLCAwLCBzaXplb2YoYWRkcikpOwogCQlpZiAoQUNQSV9GQUlMVVJFKGFjcGlf
cmVzb3VyY2VfdG9fYWRkcmVzczY0KGFjcGlfcmVzLCAmYWRkcikpKQogCQkJcmV0dXJuIEFFX09L
OwogCkBAIC0yNjEsMzQgKzI2MCwzMyBAQCBzdGF0aWMgYWNwaV9zdGF0dXMgc2V0dXBfcmVzb3Vy
Y2Uoc3RydWN0CiAJCQlyLmZsYWdzIHw9IElPUkVTT1VSQ0VfUFJFRkVUQ0g7CiAKIAkJdHJhbnNs
YXRpb25fb2Zmc2V0ID0gYWRkci50cmFuc2xhdGlvbl9vZmZzZXQ7Ci0JCW9yaWdfZW5kID0gci5l
bmQ7CiAJCXIuc3RhcnQgKz0gdHJhbnNsYXRpb25fb2Zmc2V0OwogCQlyLmVuZCArPSB0cmFuc2xh
dGlvbl9vZmZzZXQ7CisJfSBlbHNlCisJCXJldHVybiBBRV9PSzsKIAotCQkvKiBFeGNsdWRlIG5v
bi1hZGRyZXNzYWJsZSByYW5nZSBvciBub24tYWRkcmVzc2FibGUgcG9ydGlvbiBvZiByYW5nZSAq
LwotCQlyLmVuZCA9IG1pbihyLmVuZCwgaW9tZW1fcmVzb3VyY2UuZW5kKTsKLQkJaWYgKHIuZW5k
IDw9IHIuc3RhcnQpIHsKLQkJCWRldl9pbmZvKCZpbmZvLT5icmlkZ2UtPmRldiwKLQkJCQkiaG9z
dCBicmlkZ2Ugd2luZG93IFslI2xseC0lI2xseF0gKGlnbm9yZWQsIG5vdCBDUFUgYWRkcmVzc2Fi
bGUpXG4iLAotCQkJCSAodW5zaWduZWQgbG9uZyBsb25nKXIuc3RhcnQsIG9yaWdfZW5kKTsKLQkJ
CXJldHVybiBBRV9PSzsKLQkJfSBlbHNlIGlmIChvcmlnX2VuZCAhPSByLmVuZCkgewotCQkJZGV2
X2luZm8oJmluZm8tPmJyaWRnZS0+ZGV2LAotCQkJCSJob3N0IGJyaWRnZSB3aW5kb3cgWyUjbGx4
LSUjbGx4XSAoWyUjbGx4LSUjbGx4XSBpZ25vcmVkLCBub3QgQ1BVIGFkZHJlc3NhYmxlKVxuIiwK
LQkJCQkgKHVuc2lnbmVkIGxvbmcgbG9uZylyLnN0YXJ0LCBvcmlnX2VuZCwKLQkJCQkgKHVuc2ln
bmVkIGxvbmcgbG9uZylyLmVuZCArIDEsIG9yaWdfZW5kKTsKLQkJfQorCS8qIEV4Y2x1ZGUgbm9u
LWFkZHJlc3NhYmxlIHJhbmdlIG9yIG5vbi1hZGRyZXNzYWJsZSBwb3J0aW9uIG9mIHJhbmdlICov
CisJb3JpZ19lbmQgPSByLmVuZDsKKwlyLmVuZCA9IG1pbihyLmVuZCwgaW9tZW1fcmVzb3VyY2Uu
ZW5kKTsKKwlpZiAoci5lbmQgPD0gci5zdGFydCkgeworCQlkZXZfaW5mbygmaW5mby0+YnJpZGdl
LT5kZXYsCisJCQkiaG9zdCBicmlkZ2Ugd2luZG93IFslI2xseC0lI2xseF0gKGlnbm9yZWQsIG5v
dCBDUFUgYWRkcmVzc2FibGUpXG4iLAorCQkJICh1bnNpZ25lZCBsb25nIGxvbmcpci5zdGFydCwg
b3JpZ19lbmQpOworCQlyZXR1cm4gQUVfT0s7CisJfSBlbHNlIGlmIChvcmlnX2VuZCAhPSByLmVu
ZCkgeworCQlkZXZfaW5mbygmaW5mby0+YnJpZGdlLT5kZXYsCisJCQkiaG9zdCBicmlkZ2Ugd2lu
ZG93IFslI2xseC0lI2xseF0gKFslI2xseC0lI2xseF0gaWdub3JlZCwgbm90IENQVSBhZGRyZXNz
YWJsZSlcbiIsCisJCQkgKHVuc2lnbmVkIGxvbmcgbG9uZylyLnN0YXJ0LCBvcmlnX2VuZCwKKwkJ
CSAodW5zaWduZWQgbG9uZyBsb25nKXIuZW5kICsgMSwgb3JpZ19lbmQpOwogCX0KIAotCWlmIChy
LmZsYWdzICYmIHJlc291cmNlX3NpemUoJnIpKSB7Ci0JCXIubmFtZSA9IGluZm8tPm5hbWU7Ci0J
CWluZm8tPnJlc1tpbmZvLT5yZXNfbnVtXSA9IHI7Ci0JCWluZm8tPnJlc19vZmZzZXRbaW5mby0+
cmVzX251bV0gPSB0cmFuc2xhdGlvbl9vZmZzZXQ7Ci0JCWluZm8tPnJlc19udW0rKzsKLQkJaWYg
KCFwY2lfdXNlX2NycykKLQkJCWRldl9wcmludGsoS0VSTl9ERUJVRywgJmluZm8tPmJyaWRnZS0+
ZGV2LAotCQkJCSAgICJob3N0IGJyaWRnZSB3aW5kb3cgJXBSIChpZ25vcmVkKVxuIiwgJnIpOwot
CX0KKwlyLm5hbWUgPSBpbmZvLT5uYW1lOworCWluZm8tPnJlc1tpbmZvLT5yZXNfbnVtXSA9IHI7
CisJaW5mby0+cmVzX29mZnNldFtpbmZvLT5yZXNfbnVtXSA9IHRyYW5zbGF0aW9uX29mZnNldDsK
KwlpbmZvLT5yZXNfbnVtKys7CisJaWYgKCFwY2lfdXNlX2NycykKKwkJZGV2X3ByaW50ayhLRVJO
X0RFQlVHLCAmaW5mby0+YnJpZGdlLT5kZXYsCisJCQkiaG9zdCBicmlkZ2Ugd2luZG93ICVwUiAo
aWdub3JlZClcbiIsICZyKTsKIAogCXJldHVybiBBRV9PSzsKIH0KSW5kZXg6IGxpbnV4LTIuNi9k
cml2ZXJzL2FjcGkvcmVzb3VyY2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2
ZXJzL2FjcGkvcmVzb3VyY2UuYworKysgbGludXgtMi42L2RyaXZlcnMvYWNwaS9yZXNvdXJjZS5j
CkBAIC0xOTksNyArMTk5LDcgQEAgYm9vbCBhY3BpX2Rldl9yZXNvdXJjZV9hZGRyZXNzX3NwYWNl
KHN0cgogCX0KIAogCXN0YXR1cyA9IGFjcGlfcmVzb3VyY2VfdG9fYWRkcmVzczY0KGFyZXMsICZh
ZGRyKTsKLQlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpCisJaWYgKEFDUElfRkFJTFVSRShzdGF0
dXMpIHx8ICFhZGRyLmFkZHJlc3NfbGVuZ3RoKQogCQlyZXR1cm4gZmFsc2U7CiAKIAlyZXMtPnN0
YXJ0ID0gYWRkci5taW5pbXVtOwo=
--089e0158aa1cb63d850509d4ce6f--
