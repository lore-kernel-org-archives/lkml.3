Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3KFT7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:59:09 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:36108 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab3KFT7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:59:07 -0500
Message-ID: <527A9F87.2070400@vmware.com>
Date: Wed, 06 Nov 2013 20:59:03 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RFC: get_dma_buf_unless_zero ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone else but me that feels such a function could be useful?

My main use-case is that it would resolve the mutual refcounting problem:

1) drm buffer object caches a dma_buf pointer which it refcounts
2) The dma-buf holds a refcount to the buffer.

This is resolved today by having the user-space visible part of the 
drm-buffer holding the refcount to the dma_buf. When user-space closes 
the drm-buffer, the reference goes away, and eventually the buffer is 
freed, when all external dma-buf users are done with the dma-buf

However, this also means that the dma-buf remains for the buffer 
lifetime even when there are no external users, which bugs me a bit.

This can be resolved by viewing the drm buffer as a lookup structure 
that doesn't hold a refcount to the dma-buf, but that means that the 
lookup structure (buffer) would need to share locks with the dma-buf 
implementation, unless we have a get_dma_buf_unless_zero, which means we 
can use locks local to the lookup structure, the drm buffer.
(See the last part of the kref documentation for a detailed discussion 
of this).

Now I don't think keeping the dma_buf for the drm buffer lifetime is a 
HUGE problem, but I just wanted to get people's views of this.

Thanks,
Thomas
