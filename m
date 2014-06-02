Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaFBRLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:11:49 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:60606 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaFBRLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:11:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140602151454.GK32082@beef>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
	<1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
	<7978295.UBGxYvcnvH@wuerfel>
	<CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
	<20140529154348.GH32082@beef>
	<CABb+yY2PiGpqy2uevCFexAKeS4aZxJxZHEDJTRN1SW6VVjBzGQ@mail.gmail.com>
	<20140602151454.GK32082@beef>
Date: Mon, 2 Jun 2014 22:41:44 +0530
Message-ID: <CABb+yY3ZYqtT+R0PwZDtpW0O0SsbxTyiYmXaseZHoj4Nr6UBPQ@mail.gmail.com>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Matt Porter <mporter@linaro.org>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 8:44 PM, Matt Porter <mporter@linaro.org> wrote:
> On Fri, May 30, 2014 at 11:01:55AM +0530, Jassi Brar wrote:
>
>>  Being more specific to your platform, I think you need some server
>> code (mailbox's client) that every driver (like clock, pmu, pinmux
>> etc) registers with to send messages to remote and receive commands
>> from remote ... perhaps by registering some filter to sort out
>> messages for each driver.
>
> Right, and here's where you hit on the problem. This server you mention
> is not a piece of hardware, it would be a software construct. As such, it
> doesn't fit into the DT binding as it exists. It's probably best to
> illustrate in DT syntax.
>
> If I were to represent the hardware relationship in the DT binding now
> it would look like this:
>
> ---
> cpm: mailbox@deadbeef {
>         compatible = "brcm,bcm-cpm-mailbox";
>         reg = <...>;
>         #mbox-cells <1>;
>         interrupts = <...>;
> };
>
> /* clock complex */
> ccu {
>         compatible = "brcm,bcm-foo-ccu";
>         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
>         mbox-names = "system";
>         /* leaving out other mailboxes for brevity */
>         #clock-cells <1>;
>         clock-output-names = "bar",
>                              "baz";
> };
>
> pmu {
>         compatible = "brcm,bcm-foo-pmu"
>         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
>         mbox-names = "system";
> };
>
> pinmux {
>         compatible = "brcm,bcm-foo-pinctrl";
>         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
>         mbox-names = "system";
> };
> ---
Yeah, I too don't think its a good idea.


> What we would need to do is completely ignore this information in each
> of the of the client drivers associated with the clock, pmu, and pinmux
> devices. This IPC server would need to be instantiated and get the
> mailbox information from some source. mbox_request_channel() only works
> when the client has an of_node with the mbox-names property present.
> Let's say we follow this model and represent it in DT:
>
> --
> cpm: mailbox@deadbeef {
>         compatible = "brcm,bcm-cpm-mailbox";
>         reg = <...>;
>         #mbox-cells <1>;
>         interrupts = <...>;
> };
>
> cpm_ipc {
>         compatible = "brcm,bcm-cpm-ipc";
>         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
>         mbox-names = "system";
>         /* leaving out other mailboxes for brevity */
> };
> ---
>
> This would allow an ipc driver to exclusively own this system channel,
> but now we've invented a binding that doesn't reflect the hardware at
> all. It's describing software so I don't believe the DT maintainers will
> allow this type of construct.
>
Must the server node specify MMIO and an IRQ, to be acceptable? Like ...

cpm_ipc : cpm@deadbeef {
         compatible = "brcm,bcm-cpm-ipc";
       /*  reg = <0xdeadbeef 0x100>; */
       /*  interrupts = <0 123 4>;  */
         mbox = <&cpm CPM_SYSTEM_CHANNEL>;
         mbox-names = "system";
};

cpm_ipc already specifies a hardware resource (mbox) that its driver
needs, I think that should be enough reason. If it were some purely
soft property for the driver like
      mode = "poll";  //or "irq"
then the node wouldn't be justified because that is the job of a
build-time config or run-time module option.

Regards,
-Jassi
