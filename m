Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaLWUqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:46:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:30573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaLWUqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:46:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,633,1413270000"; 
   d="scan'208";a="642091244"
Date: Tue, 23 Dec 2014 12:47:55 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        mina86@mina86.com, m.szyprowski@samsung.com, k.opasiak@samsung.com,
        stern@rowland.harvard.edu
Subject: Re: [PATCH v5] usb: gadget: f_fs: add "no_disconnect" mode
Message-ID: <20141223204755.GC19996@psi-dev26.jf.intel.com>
References: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
 <20141223184858.GM9147@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223184858.GM9147@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 12:48:58PM -0600, Felipe Balbi wrote:
> On Thu, Dec 18, 2014 at 09:55:10AM +0100, Robert Baldyga wrote:
> > Since we can compose gadgets from many functions, there is the problem
> > related to gadget breakage while FunctionFS daemon being closed. FFS
> > function is userspace code so there is no way to know when it will close
> > files (it doesn't matter what is the reason of this situation, it can
> > be daemon logic, program breakage, process kill or any other). So when
> > we have another function in gadget which, for example, sends some amount
> > of data, does some software update or implements some real-time functionality,
> > we may want to keep the gadget connected despite FFS function is no longer
> > functional.
> > 
> > We can't just remove one of functions from gadget since it has been
> > enumerated, so the only way to keep entire gadget working is to make
> > broken FFS function deactivated but still visible to host. For this
> > purpose this patch introduces "no_disconnect" mode. It can be enabled
> > by setting mount option "no_disconnect=1", and results with defering
> > function disconnect to the moment of reopen ep0 file or filesystem
> > unmount. After closing all endpoint files, FunctionFS is set to state
> > FFS_DEACTIVATED.
> > 
> > When ffs->state == FFS_DEACTIVATED:
> > - function is still bound and visible to host,
> > - setup requests are automatically stalled,
> > - transfers on other endpoints are refused,
> > - epfiles, except ep0, are deleted from the filesystem,
> > - opening ep0 causes the function to be closed, and then FunctionFS
> >   is ready for descriptors and string write,
> > - altsetting change causes the function to be closed - we want to keep
> >   function alive until another functions are potentialy used, altsetting
> >   change means that another configuration is being selected or USB cable
> >   was unplugged, which indicates that we don't need to stay longer in
> >   FFS_DEACTIVATED state
> > - unmounting of the FunctionFS instance causes the function to be closed.
> > 
> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> 
> David, can you test it with your setup ?

Works fine on my side.
Tested-by: David Cohen <david.a.cohen@linux.intel.com>

> 
> cheers
> 
> -- 
> balbi


