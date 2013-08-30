Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3H3JNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:13:53 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:58189 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3H3JNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:13:50 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <CAJfpegszfc9_ZkGGHg84VvOdmWz1=zWCnHRDbVOWf6_c-oJAXA@mail.gmail.com>
References: <20130812163935.10366.88320.stgit@maximpc.sw.ru>
	<20130816112854.5630.1907.stgit@maximpc.sw.ru>
	<20130829154110.GB19636@tucsk.piliscsaba.szeredi.hu>
	<521F7672.7050407@parallels.com>
	<20130829163744.GC19636@tucsk.piliscsaba.szeredi.hu>
	<CAJfpegszfc9_ZkGGHg84VvOdmWz1=zWCnHRDbVOWf6_c-oJAXA@mail.gmail.com>
Date: Fri, 30 Aug 2013 11:13:48 +0200
Message-ID: <CAJfpegueaj7dF1SL68=pKSTO-q6RnbD-D=C65B8RGEPC4_DMfQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate() -v2
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 6:41 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> BTW, isn't it enough to do the filemap_write_and_wait() *plus* the
> fuse_set_nowrite()?

Thought about it a bit and I think this should do fine.

Any writes before the fallocate will go trough before the fallocate.
i_mutex guarantees that only one instance of fuse_set_nowrite() is
running.  Any mmaped writes during the fallocate() will go after the
fallocate request and the page cache truncation and that's fine too.
Page cache is consistent since it doens't contain pages for those
writes to the hole.  Subsequent reads to that area will fill them in.

Any other concerns?

Thanks,
Miklos
