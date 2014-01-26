Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaAZJV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:21:57 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52768 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaAZJVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:21:53 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1390697490.4025.29.camel@ideak-mobl>
References: <1390554955-26380-1-git-send-email-imre.deak@intel.com>
	<1390567654-27547-1-git-send-email-imre.deak@intel.com>
	<20140125203737.GN9772@phenom.ffwll.local>
	<1390697490.4025.29.camel@ideak-mobl>
Date: Sun, 26 Jan 2014 10:21:52 +0100
X-Google-Sender-Auth: 1ceS8Lkx4-IDwo33rTpB7VCGxKI
Message-ID: <CAKMK7uGQ-jj7rUzoJ4MuTMzbASBP_1wjnC0DEuOivd6SA8FBQA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: fix dp/sdvo i2c cleanup
From: Daniel Vetter <daniel@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 1:51 AM, Imre Deak <imre.deak@intel.com> wrote:
> On Sat, 2014-01-25 at 21:37 +0100, Daniel Vetter wrote:
>> On Fri, Jan 24, 2014 at 02:47:33PM +0200, Imre Deak wrote:
>> > Atm we try to remove the connector's i2c sysfs entry too late in the
>> > encoder's destroy callback. By that time the kobject used as the parent
>> > for all connector sysfs entries is already removed when we do an early
>> > removal of all connector sysfs entries in intel_modeset_cleanup(). Fix
>> > this by adding an early_destroy encoder callback, where we remove the
>> > encoder's i2c adapter.
>> >
>> > v2:
>> > - add missing static to function, use existing sdvo cast helper,
>> >   s/intel_sdvo/sdvo/ (Chris)
>> >
>> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=70523
>> >
>> > Signed-off-by: Imre Deak <imre.deak@intel.com>
>>
>> This looks fishy ... sysfs should all be reference-counted, so I'm
>> confused what's going on here. Also I think this smells a bit like it's
>> going overall in the wrong direction - essentially with sysfs we can't
>> really force-remove stuff but have to wait until the refcount drops to 0.
>> Or at least that's how I think it works, I'd need to blow through a pile
>> of time to figure this all out.
>
> Hm, I haven't thought about refcounting :) Now, I agree that should
> normally allow for removing a parent and child device in both order.
>
> What happens and why we can't remove first the parent then the child:
>
> In
>
> intel_dp_init_connector()->
>   intel_dp_i2c_init()
>
> we set the i2c adapter.dev.parent = intel_connector->base.kdev;
>
> device_register will then add the i2c sysfs entry to the connector sysfs
> dir. Refcounting here looks ok, both the parent connector kobject and
> its sysfs dir entry gets a reference from the child.
>
> During module cleanup, we call
>
> intel_modeset_cleanup()->
>   drm_sysfs_connector_remove()
>     device_unregister(connector->kdev)
>
> which is the i2c adapter's parent kdev. Then:
>
> device_del()->
>   kobject_del()->
>     sysfs_remove_dir()
>
> will remove all entries recursively in the connector's sysfs dir, along
> with all the i2c sysfs entries. Afterwards the intel encoder->destroy()
> callback calls i2c_del_adapter()->device_unregister()->device_del() and
> that will try to remove its own sysfs attributes, namely the power sysfs
> group, but won't find it since it was removed above and give a WARN.
>
> Note that the parent's recursive removal happens regardless of its
> kobject's or sysfs entry's refcount. The kobject itself will be put
> after device_del() in put_device() and only destroyed after the i2c
> adapter releases the refcount it holds on it. I admit it feels strange
> that the sysfs entries are removed before the last reference on the
> kobject is dropped, not sure if it's by design or an overlook..

I have no idea either how exactly this is supposed to work, and I
quick scan through Documentation/ didn't point me into a useful
direction either.

Adding Greg (and more mailing lists) for insight.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
