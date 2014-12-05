Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaLEODw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:03:52 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41300 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaLEODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:03:50 -0500
Date: Fri, 5 Dec 2014 15:04:20 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jeremiah Mahler <jmmahler@gmail.com>, Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org, weiyj_lk@163.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: release struct_mutex on the
 i915_gem_init_hw fail path
Message-ID: <20141205140420.GM20350@phenom.ffwll.local>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	intel-gfx@lists.freedesktop.org, weiyj_lk@163.com,
	linux-kernel@vger.kernel.org
References: <20141205013911.GA1510@hudson.localdomain>
 <1417781862-23368-1-git-send-email-jani.nikula@intel.com>
 <1417781862-23368-2-git-send-email-jani.nikula@intel.com>
 <20141205130314.GA2658@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205130314.GA2658@hudson.localdomain>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 05:03:14AM -0800, Jeremiah Mahler wrote:
> Jani,
> 
> On Fri, Dec 05, 2014 at 02:17:42PM +0200, Jani Nikula wrote:
> > Release struct_mutex if init_rings() fails.
> > 
> > This is a regression introduced in
> > commit 35a57ffbb10840af219eeaf64718434242bb7c76
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Thu Nov 20 00:33:07 2014 +0100
> > 
> >     drm/i915: Only init engines once
> > 
> > Reported-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > ---
> >  drivers/gpu/drm/i915/i915_gem.c | 16 +++++++---------
> >  1 file changed, 7 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> > index c1c11418231b..e3ce4bef22a3 100644
> > --- a/drivers/gpu/drm/i915/i915_gem.c
> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > @@ -4860,22 +4860,18 @@ int i915_gem_init(struct drm_device *dev)
> >  	}
> >  
> >  	ret = i915_gem_init_userptr(dev);
> > -	if (ret) {
> > -		mutex_unlock(&dev->struct_mutex);
> > -		return ret;
> > -	}
> > +	if (ret)
> > +		goto out_unlock;
> >  
> >  	i915_gem_init_global_gtt(dev);
> >  
> >  	ret = i915_gem_context_init(dev);
> > -	if (ret) {
> > -		mutex_unlock(&dev->struct_mutex);
> > -		return ret;
> > -	}
> > +	if (ret)
> > +		goto out_unlock;
> >  
> >  	ret = dev_priv->gt.init_rings(dev);
> >  	if (ret)
> > -		return ret;
> > +		goto out_unlock;
> >  
> >  	ret = i915_gem_init_hw(dev);
> >  	if (ret == -EIO) {
> > @@ -4887,6 +4883,8 @@ int i915_gem_init(struct drm_device *dev)
> >  		atomic_set_mask(I915_WEDGED, &dev_priv->gpu_error.reset_counter);
> >  		ret = 0;
> >  	}
> > +
> > +out_unlock:
> >  	mutex_unlock(&dev->struct_mutex);
> >  
> >  	return ret;
> > -- 
> > 2.1.3
> > 
> 
> Yes, this looks much better.

Oh well confusion in my mailbox. I've dropped Wei's patch and merged this
one instead.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
