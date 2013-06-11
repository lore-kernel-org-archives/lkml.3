Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3FKPmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:42:54 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1414 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab3FKPmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:42:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,845,1363132800"; 
   d="scan'208";a="30476785"
Message-ID: <51B743EA.5020800@eu.citrix.com>
Date: Tue, 11 Jun 2013 16:36:10 +0100
From: George Dunlap <george.dunlap@eu.citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xen/pci: Deal with toolstack missing an 'XenbusStateClosing'.
References: <20130610202456.GA17822@phenom.dumpdata.com> <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com> <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 10:06 PM, Konrad Rzeszutek Wilk wrote:
> There are two tool-stack that can instruct the Xen PCI frontend
> and backend to change states: 'xm' (Python code with a daemon),
> and 'xl' (C library - does not keep state changes).
>
> With the 'xm', the path to disconnect a PCI device (xm pci-detach
> <guest> <BDF>)is:
>
> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)->5(Closing*).
>
> The * is for states that the tool-stack sets. For 'xl', it is similar:
>
> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)
>
> Both of them also tear down the XenBus structure, so the backend
> state ends up going in the 3(Initialised) and calls pcifront_xenbus_remove.

So I looked a little bit into this; there are actually two different 
states that happen as part of this handshake.  In order to disonnect a 
*device*, xl signals using the *bus* state, like this:
* Wait for the *bus* to be in state 4(Connected)
* Set the *device* state to 5(Closing)
* Set the *bus* state to 7(Reconfiguring)
* Wait for the *bus* state to return to 4(Connected)

So are all of these states you see the *bus* state?  And why would you 
disconnect the whole pci bus if you're only removing one device?

  -George
