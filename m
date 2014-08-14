Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaHNQnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:43:32 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:49942
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751110AbaHNQna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:43:30 -0400
Message-ID: <53ECE709.5030008@chelsio.com>
Date: Thu, 14 Aug 2014 09:42:49 -0700
From: Casey Leedom <leedom@chelsio.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Anish Bhatt <anish@chelsio.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Benjamin Poirier <bpoirier@suse.de>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        Santosh Rastapur <santosh@chelsio.com>,
        "MPT-FusionLinux.pdl@avagotech.com" 
	<MPT-FusionLinux.pdl@avagotech.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] cxgb4: use module_long_probe_init()
References: <1407882507-325-1-git-send-email-mcgrof@do-not-panic.com>,<1407882507-325-3-git-send-email-mcgrof@do-not-panic.com> <525DB349B3FB5444AE057A887CB2A8D85A0977@nice.asicdesigners.com>
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D85A0977@nice.asicdesigners.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/13/2014 04:33 PM, Anish Bhatt wrote:
> Adding Casey who's actually incharge of this code and missing from the CC list

   Thanks Anish!

   As I mentioned to Anish, there are fundamentally two problems here in 
the time being consumed by the cxgb4 PCI probe() function:

  1. When various firmware files aren't present, request_firmware()
     can take a very long time.  This is easily solved by using
     request_firmware_direct() and I certainly have no objection to that.

  2. When there are multiple adapters present in a system which
     need firmware downloaded, each one individually may not take
     a ton of time but together they can exceed simple Module Load
     Timeouts.  There's not a simple answer here.

   Part of the problem here is that it's a Module Load Timeout instead 
of a per-device Probe Timeout.   Part of the problem is that the current 
architecture has Device Probe happening out of the Module Initialization 
when we call pci_register_driver() with our PCI Device ID Table.

   Running the Device Probes asynchronously has been discussed but that 
has the problem that it's then impossible to return the Device Probe 
Status.  This is a problem for Driver Fallback and, if the probe fails, 
we're not supposed to call the Device Remove function. To make this 
work, the synchronous/asynchronous boundary would really need to be up 
in the PCI Infrastructure layer so the Device Probe status could be 
captured in the normal logic.  This would be a moderately large change 
there ...

   Deferring the Device Initialization till the first "ifup" has also 
been discussed and is certainly possible, though a moderately large 
architectural change to every driver which needs it.  It also has the 
unfortunate effect of introducing random large delays directly on user 
commands.  From a User Experience perspective I would tend to want such 
large delays in the Device Probe.  But that's something that really 
deserves a real User Interaction study rather than throwing a dart.

   On the whole, I think that introducing these Module Load Timeouts 
hasn't been well thought out with respect to the repercussions and I'd 
be more inclined to back that out till a well thought out design is 
developed.  But I'm here for the discussion.

Casey
