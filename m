Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3AXRg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:36:58 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38877 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3AXRgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:36:55 -0500
Date: Thu, 24 Jan 2013 18:36:52 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH 59/74] drm/nv17-50: restore fence buffer on resume
Message-ID: <20130124173652.GA3123@joi.lan>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
 <1358998046-613-60-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358998046-613-60-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 01:27:11AM -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> commit f20ebd034eab43fd38c58b11c5bb5fb125e5f7d7 upstream.
> 
> Since commit 5e120f6e4b3f35b741c5445dfc755f50128c3c44 "drm/nouveau/fence:
> convert to exec engine, and improve channel sync" nouveau fence sync
> implementation for nv17-50 and nvc0+ started to rely on state of fence buffer
> left by previous sync operation. But as pinned bo's (where fence state is
> stored) are not saved+restored across suspend/resume, we need to do it
> manually.
> 
> nvc0+ was fixed by commit d6ba6d215a538a58f0f0026f0961b0b9125e8042
> "drm/nvc0/fence: restore pre-suspend fence buffer context on resume".
> 
> Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=50121
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> [ herton: backport for 3.5, looks like we only need to call
>   nouveau_bo_wr32 on nv10_fence_init ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> ---
>  drivers/gpu/drm/nouveau/nv10_fence.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/nv10_fence.c b/drivers/gpu/drm/nouveau/nv10_fence.c
> index 8a1b750..18932a6 100644
> --- a/drivers/gpu/drm/nouveau/nv10_fence.c
> +++ b/drivers/gpu/drm/nouveau/nv10_fence.c
> @@ -155,6 +155,9 @@ nv10_fence_fini(struct drm_device *dev, int engine, bool suspend)
>  static int
>  nv10_fence_init(struct drm_device *dev, int engine)
>  {
> +	struct nv10_fence_priv *priv = nv_engine(dev, engine);
> +
> +	nouveau_bo_wr32(priv->bo, 0, priv->sequence);
>  	return 0;
>  }
>  
> -- 

As I already mentioned in linked bug report, this backport will crash on module
load for nv10-nv17 cards. priv->bo is created only for chipsets >= nv17.

You need to add "if (priv->bo)" before nouveau_bo_wr32.

Marcin
