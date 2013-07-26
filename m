Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3GZMg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:36:27 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:56714 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab3GZMgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <51F23D0F.7090909@oracle.com>
References: <51F23D0F.7090909@oracle.com>
Date: Fri, 26 Jul 2013 05:36:23 -0700
X-Google-Sender-Auth: YDOlETY-RxB6qOTVOCEyvSEPKiI
Message-ID: <CAE9FiQVvOe9pOmLLKRUWzSmHLWvv6S32LUYARCG3MoLMJpATXQ@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert
From: Yinghai Lu <yinghai@kernel.org>
To: ethan zhao <ethan.zhao@oracle.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ethan.kernel@gmail.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 2:10 AM, ethan zhao <ethan.zhao@oracle.com> wrote:
> Cleanup the -EINVAL return value handling and add warning message for
> invalid
> start,end,addr parameters.
>
> Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
> ---
>  arch/x86/pci/mmconfig-shared.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 082e881..37f6c7f 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -700,8 +700,13 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8
> start, u8 end,
>      if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
>          return -ENODEV;
>
> -    if (start > end)
> +    if (start > end || !addr) {
> +        dev_warn(dev, FW_WARN
> +                                 "Invalid address to add MMCONFIG"
> +                                 "start %02x end %02x addr %pR\n",
> +                                  start, end, addr);
>          return -EINVAL;
> +    }
>
>      mutex_lock(&pci_mmcfg_lock);
>      cfg = pci_mmconfig_lookup(seg, start);
> @@ -716,11 +721,6 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8
> start, u8 end,
>          return -EEXIST;
>      }
>
> -    if (!addr) {
> -        mutex_unlock(&pci_mmcfg_lock);
> -        return -EINVAL;
> -    }
> -
>      rc = -EBUSY;
>      cfg = pci_mmconfig_alloc(seg, start, end, addr);
>      if (cfg == NULL) {


Acked-by: Yinghai Lu <yinghai@kerne.org>
