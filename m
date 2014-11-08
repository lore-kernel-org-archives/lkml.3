Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaKHTIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 14:08:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaKHTIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 14:08:10 -0500
Date: Sat, 8 Nov 2014 11:06:55 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Message-ID: <20141108190655.GA2638@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 11:07:08AM +0800, Kweh Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> Besides aborting through user helper interface, a new API
> request_firmware_abort() allows kernel driver module to abort the
> request_firmware() / request_firmware_nowait() when they are no
> longer needed. It is useful for cancelling an outstanding firmware
> load if initiated from inside a module where that module is in the
> process of being unloaded, since the unload function may not have
> a handle to the struct firmware_buf.
> 
> Note for people who use request_firmware_nowait():
> You are required to do your own synchronization after you call
> request_firmware_abort() in order to continue unloading the
> module. The example synchronization code shows below:
> 
> while (THIS_MODULE && module_refcount(THIS_MODULE))
> 	msleep(20);

As others have pointed out, this isn't ok, and is totally racy and
should never end up in a driver.  Never mess with THIS_MODULE from
within the same module, otherwise it's racy and broken code.

So can you please rework this to not require this?

thanks,

greg k-h
