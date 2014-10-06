Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaJFMJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:09:47 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:55350 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaJFMJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:09:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation for the dma controller API
Date: Mon, 06 Oct 2014 15:09:48 +0300
Message-ID: <7725507.nuHj4C7OxF@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1411746035-15882-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com> <1411746035-15882-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for working on this. Please see below for a couple of comments in 
addition to Randy's proof-reading.

On Friday 26 September 2014 17:40:35 Maxime Ripard wrote:
> The dmaengine is neither trivial nor properly documented at the moment,
> which means a lot of trial and error development, which is not that good
> for such a central piece of the system.
> 
> Attempt at making such a documentation.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  Documentation/dmaengine/provider.txt | 358 ++++++++++++++++++++++++++++++++
>  1 file changed, 358 insertions(+)
>  create mode 100644 Documentation/dmaengine/provider.txt
> 
> diff --git a/Documentation/dmaengine/provider.txt
> b/Documentation/dmaengine/provider.txt new file mode 100644
> index 000000000000..ba407e706cde
> --- /dev/null
> +++ b/Documentation/dmaengine/provider.txt
> @@ -0,0 +1,358 @@
> +DMAengine controller documentation
> +==================================
> +
> +Hardware Introduction
> ++++++++++++++++++++++
> +
> +Most of the Slave DMA controllers have the same general principles of
> +operations.
> +
> +They have a given number of channels to use for the DMA transfers, and
> +a given number of requests lines.
> +
> +Requests and channels are pretty much orthogonal. Channels can be used
> +to serve several to any requests. To simplify, channels are the
> +entities that will be doing the copy, and requests what endpoints are
> +involved.
> +
> +The request lines actually correspond to physical lines going from the
> +DMA-elligible devices to the controller itself. Whenever the device
> +will want to start a transfer, it will assert a DMA request (DRQ) by
> +asserting that request line.
> +
> +A very simple DMA controller would only take into account a single
> +parameter: the transfer size. At each clock cycle, it would transfer a
> +byte of data from one buffer to another, until the transfer size has
> +been reached.
> +
> +That wouldn't work well in the real world, since slave devices might
> +require to have to retrieve various number of bits from memory at a
> +time. For example, we probably want to transfer 32 bits at a time when
> +doing a simple memory copy operation, but our audio device will
> +require to have 16 or 24 bits written to its FIFO. This is why most if
> +not all of the DMA controllers can adjust this, using a parameter
> +called the width.

DMA engines can have buses larger than 32 bits, I would thus phrase that as 
follows.

"That wouldn't work well in the real world, since slave devices might require 
a specific number of bits to be transfered in a single cycle. For example, we 
may want to transfer as much data as the physical bus allows to maximize 
performances when doing a simple memory copy operation, but our audio device 
could have a narrower FIFO that requires data to be written exactly 16 or 24 
bits at a time. This is why most if not all of the DMA controllers can adjust 
this, using a parameter called the transfer width."

> +Moreover, some DMA controllers, whenever the RAM is involved, can

s/the RAM is involved/RAM is used as a source or destination/ ?

> +group the reads or writes in memory into a buffer, so instead of
> +having a lot of small memory accesses, which is not really efficient,
> +you'll get several bigger transfers. This is done using a parameter
> +called the burst size, that defines how many single reads/writes it's
> +allowed to do in a single clock cycle.

The burst size defines "how many read or write operations can be queued to 
buffers before being flushed to memory". Several clock cycles will still most 
likely be needed, the performance improvements here come from the fact that 
the accesses can be performed in bursts.

> +Our theorical DMA controller would then only be able to do transfers
> +that involve a single contiguous block of data. However, some of the
> +transfers we usually have are not, and want to copy data from
> +non-contiguous buffers to a contiguous buffer, which is called
> +scatter-gather.
> +
> +DMAEngine, at least for mem2dev transfers, require support for
> +scatter-gather. So we're left with two cases here: either we have a
> +quite simple DMA controller that doesn't support it, and we'll have to
> +implement it in software, or we have a more advanced DMA controller,
> +that implements in hardware scatter-gather.
> +
> +The latter are usually programmed using a collection of chunks to
> +transfer, and whenever the transfer is started, the controller will go
> +over that collection, doing whatever we programmed there.
> +
> +This collection is usually either a table or a linked list. You will
> +then push either the address of the table and its number of elements,
> +or the first item of the list to one channel of the DMA controller,
> +and whenever a DRQ will be asserted, it will go through the collection
> +to know where to fetch the data from.
> +
> +Either way, the format of this collection is completely dependent of
> +your hardware. Each DMA controller will require a different structure,
> +but all of them will require, for every chunk, at least the source and
> +destination addresses, wether it should increment these addresses or
> +not and the three parameters we saw earlier: the burst size, the bus
> +width and the transfer size.

I would talk about "transfer width" here, as the transfer width can be smaller 
than the bus width (I've even seen a strange case of a transfer width larger 
than the physical bus width).

> +The one last thing is that usually, slave devices won't issue DRQ by
> +default, and you have to enable this in your slave device driver first
> +whenever you're willing to use DMA.
> +
> +These were just the general memory-to-memory (also called mem2mem) or
> +memory-to-device (mem2dev) transfers. Other kind of transfers might be
> +offered by your DMA controller, and are probably already supported by
> +dmaengine.
> +
> +DMA Support in Linux
> +++++++++++++++++++++
> +
> +Historically, DMA controller driver have been implemented using the

s/driver/drivers/

> +async TX API, to offload operations such as memory copy, XOR,
> +cryptography, etc, basically any memory to memory operation.
> +
> +Over the time, the need for memory to device transfers arose, and
> +dmaengine was extended. Nowadays, the async TX API is written as a
> +layer on top of dmaengine, and act as a client. Still, dmaengine
> +accomodates that API in some cases, and made some design choices to
> +ensure that it stayed compatible.
> +
> +For more information on the Async TX API, please look the relevant
> +documentation file in Documentation/crypto/async-tx-api.txt.
> +
> +DMAEngine Registration
> +++++++++++++++++++++++
> +
> +struct dma_device Initialization
> +--------------------------------
> +
> +Just like any other kernel framework, the whole DMAEngine registration
> +relies on the driver filling a structure and registering against the
> +framework. In our case, that structure is dma_device.
> +
> +The first thing you need to do in your driver is to allocate this
> +structure. Any of the usual memory allocator will do, but you'll also
> +need to initialize a few fields in there:
> +
> +  * chancnt:	should be the number of channels your driver is exposing
> +		to the system.
> +		This doesn't have to be the number of physical
> +		channels: some DMA controllers also expose virtual
> +		channels to the system to overcome the case where you
> +		have more consumers than physical channels available.

If I'm not mistaken the dma_async_register_device() function sets chancnt 
internally.

> +  * channels:	should be initialized as a list using the
> +		INIT_LIST_HEAD macro for example

More than that, drivers must fill that list before calling 
dma_async_register_device().

> +  * dev: 	should hold the pointer to the struct device associated
> +		to your current driver instance.
> +
> +Supported transaction types
> +---------------------------
> +The next thing you need is to actually set which transaction type your

You can drop the "actually".

s/type/types/

> +device (and driver) supports.
> +
> +Our dma_device structure has a field called caps_mask that holds the

s/caps_mask/cap_mask/

> +various types of transaction supported, and you need to modify this
> +mask using the dma_cap_set function, with various flags depending on
> +transaction types you support as an argument.
> +
> +All those capabilities are defined in the dma_transaction_type enum,
> +in include/linux/dmaengine.h
> +
> +Currently, the types available are:
> +  * DMA_MEMCPY
> +    - The device is able to do memory to memory copies
> +
> +  * DMA_XOR
> +    - The device is able to perform XOR operations on memory areas
> +    - Particularly useful to accelerate XOR intensive tasks, such as

s/- Particularly useful/  Used to/ ?

> +      RAID5
> +
> +  * DMA_XOR_VAL
> +    - The device is able to perform parity check using the XOR
> +      algorithm against a memory buffer.
> +
> +  * DMA_PQ
> +    - The device is able to perform RAID6 P+Q computations, P being a
> +      simple XOR, and Q being a Reed-Solomon algorithm.
> +
> +  * DMA_PQ_VAL
> +    - The device is able to perform parity check using RAID6 P+Q
> +      algorithm against a memory buffer.
> +
> +  * DMA_INTERRUPT
> +    /* TODO: Is it that the device has one interrupt per channel? */

If I'm not mistaken DMA_INTERRUPT means the device supports the 
device_prep_dma_interrupt() operation, which prepares a dummy transfer that 
will not transfer any data but will generate an interrupt, calling the 
complete callback.

> +
> +  * DMA_SG
> +    - The device supports memory to memory scatter-gather
> +      transfers.
> +    - Even though a plain memcpy can look like a particular case of a
> +      scatter-gather transfer, with a single chunk to transfer, it's a
> +      distinct transaction type in the mem2mem transfers case
> +
> +  * DMA_PRIVATE
> +    - The devices only supports slave transfers, and as such isn't
> +      avaible for async transfers.
> +
> +  * DMA_ASYNC_TX
> +    - Must not be set by the device, and will be set by the framework
> +      if needed
> +    - /* TODO: What is it about? */
> +
> +  * DMA_SLAVE
> +    - The device can handle device to memory transfers, including
> +      scatter-gather transfers.
> +    - While in the mem2mem case we were having two distinct types to
> +      deal with a single chunk to copy or a collection of them, here,
> +      we just have a single transaction type that is supposed to
> +      handle both.
> +
> +  * DMA_CYCLIC
> +    - The device can handle cyclic transfers.
> +    - A cyclic transfer is a transfer where the chunk collection will
> +      loop over itself, with the last item pointing to the first. It's
> +      usually used for audio transfers, where you want to operate on a
> +      single big buffer that you will fill with your audio data.

The buffer doesn't have to be big, I would s/big buffer/ring buffer/.

> +
> +  * DMA_INTERLEAVE
> +    - The device supports interleaved transfer. Those transfers
> +      usually involve an interleaved set of data, with chunks a few
> +      bytes wide, where a scatter-gather transfer would be quite
> +      inefficient.

This is typically used to transfer 2D content such as uncompressed video.

> +These various types will also affect how the source and destination
> +addresses change over time, as DMA_SLAVE transfers will usually have
> +one of the addresses that will increment, while the other will not,
> +DMA_CYCLIC will have one address that will loop, while the other, will

s/the other,/the other/

> +not change, etc.
> +
> +Device operations
> +-----------------
> +
> +Our dma_device structure also requires a few function pointers in
> +order to implement the actual logic, now that we described what
> +operations we were able to perform.
> +
> +The functions that we have to fill in there, and hence have to
> +implement, obviously depend on the transaction types you reported as
> +supported.
> +
> +   * device_alloc_chan_resources
> +   * device_free_chan_resources
> +     - These functions will be called whenever a driver will call
> +       dma_request_channel or dma_release_channel for the first/last
> +       time on the channel associated to that driver.
> +     - They are in charge of allocating/freeing all the needed
> +       resources in order for that channel to be useful for your
> +       driver.
> +     - These functions can sleep.
> +
> +   * device_prep_dma_*
> +     - These functions are matching the capabilities you registered
> +       previously.
> +     - These functions all take the buffer or the scatterlist relevant
> +       for the transfer being prepared, and should create a hardware
> +       descriptor or a list of descriptors from it
> +     - These functions can be called from an interrupt context
> +     - Any allocation you might do should be using the GFP_NOWAIT
> +       flag, in order not to potentially sleep, but without depleting
> +       the emergency pool either.

You could add "Drivers should try to preallocate the data structures they 
require to prepare a transfer."

> +
> +     - It should return a unique instance of the
> +       dma_async_tx_descriptor structure, that further represents this
> +       particular transfer.
> +
> +     - This structure can be allocated using the function
> +       dma_async_tx_descriptor_init.

That function only initializes the tx descriptor, it doesn't allocate it.

> +     - You'll also need to set two fields in this structure:
> +       + flags:
> +		TODO: Can it be modified by the driver itself, or
> +		should it be always the flags passed in the arguments
> +
> +       + tx_submit:	A pointer to a function you have to implement,
> +			that is supposed to push the current descriptor
> +			to a pending queue, waiting for issue_pending to
> +			be called.
> +
> +   * device_issue_pending
> +     - Takes the first descriptor in the pending queue, and starts the
> +       transfer. Whenever that transfer is done, it should move to the
> +       next transaction in the list.
> +     - It should call the registered callback if any each time a
> +       transaction is done.
> +     - This function can be called in an interrupt context
> +
> +   * device_tx_status
> +     - Should report the bytes left to go over on the given channel
> +     - Should also only concern about the given descriptor, not the
> +       currently active one.

I have to guess what you mean here :-)

> +     - The tx_state argument might be NULL
> +     - Should use dma_set_residue to report it
> +     - In the case of a cyclic transfer, it should only take into
> +       account the current period.
> +     - This function can be called in an interrupt context.
> +
> +   * device_control
> +     - Used by client drivers to control and configure the channel it
> +       has a handle on.
> +     - Called with a command and an argument
> +       + The command is one of the values listed by the enum
> +         dma_ctrl_cmd. To this date, the valid commands are:

s/To this date, the/The/

> +         + DMA_RESUME
> +           + Restarts a transfer on the channel
> +           + This command should operate synchronously on the channel,
> +             resuming right away the work of the given channel
> +         + DMA_PAUSE
> +           + Pauses a transfer on the channel
> +           + This command should operate synchronously on the channel,
> +             pausing right away the work of the given channel

I think you should list DMA_PAUSE first, and then explain that DMA_RESUME 
resumes operation of a paused channel.

> +         + DMA_TERMINATE_ALL
> +           + Aborts all the pending and ongoing transfers on the
> +             channel
> +           + This command should operate synchronously on the channel,
> +             terminating right away all the channels
> +         + DMA_SLAVE_CONFIG
> +           + Reconfigures the channel with passed configuration
> +           + This command should NOT perform synchronously, or on any
> +             currently queued transfers, but only on subsequent ones
> +           + In this case, the function will receive a
> +             dma_slave_config structure pointer as an argument, that
> +             will detail which configuration to use.
> +           + Even though that structure contains a direction field,
> +             this field is deprecated in favor of the direction
> +             argument given to the prep_* functions
> +         + FSLDMA_EXTERNAL_START
> +           + TODO: Why does that even exist?
> +       + The argument is an opaque unsigned long. This actually is a
> +         pointer to a struct dma_slave_config that should be used only
> +         in the DMA_SLAVE_CONFIG.
> +
> +  * device_slave_caps
> +    - Called through the framework by client drivers in order to have
> +      an idea of what are the properties of the channel allocated to
> +      them.
> +    - Such properties are the buswidth, available directions, etc.
> +    - Required for every generic layer doing DMA transfers, such as
> +      ASoC.
> +
> +Misc notes (stuff that should be documented, but don't really know
> +where to put them)
> +------------------------------------------------------------------
> +  * dma_run_dependencies
> +    - Should be called at the end of an async TX transfer, and can be
> +      ignored ine the slave transfers case.

s/ine/in/

> +    - Makes sure that dependent operations are run before marking it
> +      as complete.
> +
> +  * dma_cookie_t
> +    - it's a DMA transaction ID, that will increment over time.
> +    - Not really relevant anymore since the introduction of virt-dma
> +      that abstracts it away.
> +
> +  * DMA_CTRL_ACK
> +    - Undocumented feature
> +    - No one really has an idea of what's it's about, beside being
> +      related to reusing the DMA descriptors or having additional
> +      transactions added to it in the async-tx API
> +    - Useless in the case of the slave API
> +
> +General Design Notes
> +--------------------
> +
> +Most of the DMAEngine drivers you'll see all are based on a similar
> +design that handles the end of transfer interrupts in the handler, but
> +defer most work to a tasklet, including the start of a new transfer
> +whenever the previous transfer ended.
> +
> +This is a rather inefficient design though, because the inter-transfer
> +latency will be not only the interrupt latency, but also the
> +scheduling latency of the tasklet, which will leave the channel idle
> +in between, which will slow down the global transfer rate.
> +
> +You should avoid this kind of pratice, and instead of electing a new
> +transfer in your tasklet, move that part to the interrupt handler in
> +order to have a shorter idle window (that we can't really avoid
> +anyway).
> +
> +Glossary
> +--------
> +
> +Burst:		Usually a few contiguous bytes that will be transfered
> +		at once by the DMA controller

A number of consecutive read or write operations that can be queued to buffers 
before being flushed to memory.

> +Chunk:		A contiguous collection of bursts
> +Transfer:	A collection of chunks (be it contiguous or not)

-- 
Regards,

Laurent Pinchart

